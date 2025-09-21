local QBCore = exports['qb-core']:GetCoreObject()
local inZone = false
local currentMenu = nil
local activeTextUI = nil -- Para controlar el TextUI activo

-- Función para mostrar texto (MODIFICADA)
function ShowTextUI(text)
    if Config.UseDPTextUI then
        exports['DP-TextUI']:MostrarUI('dp_extras_menu', text, 'E', false)
    else
        TriggerEvent('qb-core:client:DrawText', text, 'left')
    end
end

-- Función para ocultar texto (MODIFICADA)
function HideTextUI()
    if Config.UseDPTextUI then
        exports['DP-TextUI']:OcultarUI('dp_extras_menu')
    else
        TriggerEvent('qb-core:client:HideText')
    end
end

-- Función mejorada para detectar liveries
function GetVehicleLiveries(vehicle)
    local liveries = {}

    -- Método 1: Liveries normales (GetVehicleLiveryCount)
    local numLiveries = GetVehicleLiveryCount(vehicle)
    if numLiveries > 0 then
        for i = 0, numLiveries - 1 do
            table.insert(liveries, {
                id = i,
                type = "normal",
                name = "Livery " .. (i + 1)
            })
        end
    end

    -- Método 2: Liveries a través de modificaciones (para muchos vehículos civiles)
    local numMods = GetNumVehicleMods(vehicle, 48) -- MOD_LIVERY = 48
    if numMods > 0 then
        for i = 0, numMods - 1 do
            table.insert(liveries, {
                id = i,
                type = "mod",
                name = "Design " .. (i + 1)
            })
        end
    end

    -- Método 3: Verificar variaciones (para algunos vehículos)
    if numLiveries == 0 and numMods == 0 then
        -- Intentar con variaciones comunes
        for i = 0, 10 do
            if GetVehicleModVariation(vehicle, 48) or DoesExtraExist(vehicle, i) then
                table.insert(liveries, {
                    id = i,
                    type = "variation",
                    name = "Style " .. (i + 1)
                })
            end
        end
    end

    return liveries
end

-- Función para aplicar livery según el tipo
function ApplyVehicleLivery(vehicle, liveryData)
    if liveryData.type == "normal" then
        SetVehicleLivery(vehicle, liveryData.id)
    elseif liveryData.type == "mod" then
        SetVehicleMod(vehicle, 48, liveryData.id, true) -- MOD_LIVERY = 48
    elseif liveryData.type == "variation" then
        -- Alternar extra o variación
        if DoesExtraExist(vehicle, liveryData.id) then
            SetVehicleExtra(vehicle, liveryData.id, 0)
        end
    end

    ForceVehicleUpdate(vehicle)
    Citizen.Wait(100)

    -- Re-aplicar para asegurar
    if liveryData.type == "normal" then
        SetVehicleLivery(vehicle, liveryData.id)
    elseif liveryData.type == "mod" then
        SetVehicleMod(vehicle, 48, liveryData.id, true)
    end
end

-- Función para forzar la actualización de extras
function ForceVehicleUpdate(vehicle)
    if not DoesEntityExist(vehicle) then
        return
    end

    local health = GetVehicleEngineHealth(vehicle)
    local dirtLevel = GetVehicleDirtLevel(vehicle)

    -- Pequeña reparación para forzar actualización
    SetVehicleFixed(vehicle)
    Citizen.Wait(50)

    -- Restaurar valores originales
    SetVehicleEngineHealth(vehicle, health)
    SetVehicleBodyHealth(vehicle, health)
    SetVehicleDirtLevel(vehicle, dirtLevel)
end

-- Función para toggle extra sin cerrar menú (MODIFICADA)
function ToggleExtra(extraId, currentState)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle == 0 then
        return false
    end

    local newState = not currentState
    local extraValue = newState and 0 or 1

    -- Mostrar progress bar según si está activando o desactivando
    local progressText = newState and Config.Texts.applyingExtra or Config.Texts.removingExtra

    ExecuteProgressBar(progressText, Config.ProgressTimes.extra, function()
        -- Aplicar el cambio después de la progress bar
        SetVehicleExtra(vehicle, extraId, extraValue)

        -- Forzar actualización
        ForceVehicleUpdate(vehicle)

        -- Re-aplicar el cambio después de la actualización
        Citizen.Wait(100)
        SetVehicleExtra(vehicle, extraId, extraValue)

        local message = newState and Config.Texts.extraEnabled or Config.Texts.extraDisabled
        QBCore.Functions.Notify(message:gsub("{extraId}", extraId), 'success')

        -- Actualizar el menú sin cerrarlo completamente
        if currentMenu == "extras" then
            Citizen.Wait(100)
            OpenExtrasMenu()
        end
    end)

    return newState
end

-- Función para cambiar livery sin cerrar menú (MODIFICADA)
function ChangeLivery(liveryData)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle == 0 then
        return
    end

    ExecuteProgressBar(Config.Texts.applyingLivery, Config.ProgressTimes.livery, function()
        -- Aplicar el cambio después de la progress bar
        ApplyVehicleLivery(vehicle, liveryData)

        local message = Config.Texts.liveryChanged:gsub("{liveryId}", liveryData.name)
        QBCore.Functions.Notify(message, 'success')

        -- Actualizar el menú sin cerrarlo completamente
        if currentMenu == "livery" then
            Citizen.Wait(100)
            OpenLiveryMenu()
        end
    end)
end

-- Función para ejecutar progress bar
function ExecuteProgressBar(label, time, callback)
    QBCore.Functions.Progressbar("dp_extras_progress", label, time, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true
    }, {}, {}, {}, function()
        -- Completado
        if callback then
            callback()
        end
    end, function()
        -- Cancelado
        QBCore.Functions.Notify("Cancelado", "error")
    end)
end

-- Función para abrir el menú principal
function OpenVehicleMenu()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle == 0 then
        QBCore.Functions.Notify(Config.Texts.noVehicle, 'error')
        return
    end

    local menu = {{
        header = Config.Texts.mainTitle,
        isMenuHeader = true
    }, {
        header = "Livery's",
        txt = Config.Texts.liveriesOption,
        icon = Config.Icons.paintRoller,
        params = {
            event = "dp-extras:openLiveryMenu"
        }
    }, {
        header = "Extras",
        txt = Config.Texts.extrasOption,
        icon = Config.Icons.gears,
        params = {
            event = "dp-extras:openExtrasMenu"
        }
    }, {
        header = "Lavar",
        txt = Config.Texts.washOption,
        icon = Config.Icons.soap,
        params = {
            event = "dp-extras:cleanVehicle"
        }
    }, {
        header = "Reparar",
        txt = Config.Texts.repairOption,
        icon = Config.Icons.wrench,
        params = {
            event = "dp-extras:repairVehicle"
        }
    }}

    currentMenu = "main"
    exports['DP-Menu']:openMenu(menu)
end

-- Menú de Livery's MEJORADO
function OpenLiveryMenu()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle == 0 then
        return
    end

    local menu = {{
        header = Config.Texts.liveriesTitle,
        isMenuHeader = true
    }}

    -- Obtener liveries usando la función mejorada
    local liveries = GetVehicleLiveries(vehicle)
    local currentLivery = GetVehicleLivery(vehicle)
    local currentMod = GetVehicleMod(vehicle, 48)

    if #liveries > 0 then
        for _, livery in ipairs(liveries) do
            local isSelected = false

            if livery.type == "normal" then
                isSelected = (currentLivery == livery.id)
            elseif livery.type == "mod" then
                isSelected = (currentMod == livery.id)
            end

            table.insert(menu, {
                header = livery.name,
                txt = (isSelected and Config.Texts.selected or Config.Texts.clickToSelect),
                icon = Config.Icons.paintBrush,
                params = {
                    event = "dp-extras:setLivery",
                    args = {
                        liveryData = livery
                    }
                }
            })
        end
    else
        table.insert(menu, {
            header = "ESTE VEHÍCULO NO TIENE LIVERY'S",
            txt = Config.Texts.noLiveries,
            isMenuHeader = true
        })
    end

    table.insert(menu, {
        header = Config.Texts.backOption,
        icon = Config.Icons.back,
        params = {
            event = "dp-extras:openMainMenu"
        }
    })

    currentMenu = "livery"
    exports['DP-Menu']:openMenu(menu)
end

-- Menú de Extras
function OpenExtrasMenu()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle == 0 then
        return
    end

    local menu = {{
        header = Config.Texts.extrasTitle,
        isMenuHeader = true
    }}

    local hasExtras = false

    -- Verificar extras (del 1 al 14)
    for extraId = 1, 14 do
        if DoesExtraExist(vehicle, extraId) then
            hasExtras = true
            local isEnabled = IsVehicleExtraTurnedOn(vehicle, extraId) == 1

            table.insert(menu, {
                header = "Extra " .. extraId,
                txt = (isEnabled and Config.Texts.enabled or Config.Texts.disabled),
                icon = isEnabled and Config.Icons.toggleOn or Config.Icons.toggleOff,
                params = {
                    event = "dp-extras:toggleExtra",
                    args = {
                        extraId = extraId,
                        currentState = isEnabled
                    }
                }
            })
        end
    end

    if not hasExtras then
        table.insert(menu, {
            header = "ESTE VEHÍCULO NO TIENE EXTRAS",
            txt = Config.Texts.noExtras,
            isMenuHeader = true
        })
    end

    table.insert(menu, {
        header = Config.Texts.backOption,
        icon = Config.Icons.back,
        params = {
            event = "dp-extras:openMainMenu"
        }
    })

    currentMenu = "extras"
    exports['DP-Menu']:openMenu(menu)
end

-- Evento para toggle extra (MODIFICADO)
RegisterNetEvent('dp-extras:toggleExtra', function(data)
    ToggleExtra(data.extraId, data.currentState)
end)

-- Evento para cambiar livery (MODIFICADO)
RegisterNetEvent('dp-extras:setLivery', function(data)
    ChangeLivery(data.liveryData)
end)

-- Eventos para abrir menús
RegisterNetEvent('dp-extras:openMainMenu', OpenVehicleMenu)
RegisterNetEvent('dp-extras:openLiveryMenu', OpenLiveryMenu)
RegisterNetEvent('dp-extras:openExtrasMenu', OpenExtrasMenu)

-- Evento para lavar vehículo (MODIFICADO)
RegisterNetEvent('dp-extras:cleanVehicle', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle == 0 then
        return
    end

    -- Ejecutar progress bar
    ExecuteProgressBar(Config.Texts.washing, Config.ProgressTimes.wash, function()
        -- Acción completada
        SetVehicleDirtLevel(vehicle, 0.0)
        QBCore.Functions.Notify(Config.Texts.washed, 'success')

        -- Reabrir el menú principal
        Citizen.Wait(300)
        OpenVehicleMenu()
    end)
end)

-- Evento para reparar vehículo (MODIFICADO)
RegisterNetEvent('dp-extras:repairVehicle', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle == 0 then
        return
    end

    -- Ejecutar progress bar
    ExecuteProgressBar(Config.Texts.repairing, Config.ProgressTimes.repair, function()
        -- Acción completada
        SetVehicleEngineHealth(vehicle, 1000.0)
        SetVehicleBodyHealth(vehicle, 1000.0)
        SetVehicleFixed(vehicle)
        QBCore.Functions.Notify(Config.Texts.repaired, 'success')

        -- Reabrir el menú principal
        Citizen.Wait(300)
        OpenVehicleMenu()
    end)
end)

-- Dibujar marker y verificar zona
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local distance = #(playerCoords - Config.Marker.position)

        -- Solo mostrar marker si es policía
        local playerData = QBCore.Functions.GetPlayerData()
        if playerData.job and playerData.job.name == Config.JobRequired then
            if distance < Config.Marker.drawDistance then
                DrawMarker(Config.Marker.type, Config.Marker.position.x, Config.Marker.position.y,
                    Config.Marker.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Marker.size.x, Config.Marker.size.y,
                    Config.Marker.size.z, Config.Marker.color.r, Config.Marker.color.g, Config.Marker.color.b,
                    Config.Marker.color.a, Config.Marker.saltos, Config.Marker.sigue, false, Config.Marker.rotacion,
                    false, false, false)
            end

            -- Verificar si está en la zona
            if distance < Config.Marker.interactionDistance then
                if not inZone then
                    inZone = true
                    -- Usar el sistema de texto configurado
                    ShowTextUI(Config.Texts.drawText)
                end

                -- Interacción con la tecla E
                if IsControlJustReleased(0, 38) then
                    if IsPedInAnyVehicle(playerPed, false) then
                        OpenVehicleMenu()
                    else
                        QBCore.Functions.Notify(Config.Texts.noVehicle, 'error')
                    end
                end
            else
                if inZone then
                    inZone = false
                    -- Ocultar el texto
                    HideTextUI()
                end
            end
        else
            if inZone then
                inZone = false
                -- Ocultar el texto
                HideTextUI()
            end
        end
    end
end)
