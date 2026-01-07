local QBCore = exports['qb-core']:GetCoreObject()
local inZone = false
local currentMenu = nil
local activeTextUI = nil
local PlayerJob = {} -- Variable para guardar el trabajo localmente

-- ==========================================================
-- GESTIÓN DE JUGADOR Y JOB (OPTIMIZACIÓN)
-- ==========================================================

-- Obtener trabajo al iniciar
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    local PlayerData = QBCore.Functions.GetPlayerData()
    if PlayerData then
        PlayerJob = PlayerData.job
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    local PlayerData = QBCore.Functions.GetPlayerData()
    PlayerJob = PlayerData.job
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

-- ==========================================================
-- FUNCIONES UI
-- ==========================================================

function ShowTextUI(text)
    if Config.UseDPTextUI then
        exports['DP-TextUI']:MostrarUI('dp_extras_menu', text, 'E', false)
    else
        TriggerEvent('qb-core:client:DrawText', text, 'left')
    end
end

function HideTextUI()
    if Config.UseDPTextUI then
        exports['DP-TextUI']:OcultarUI('dp_extras_menu')
    else
        TriggerEvent('qb-core:client:HideText')
    end
end

-- ==========================================================
-- LÓGICA DE VEHÍCULOS (LIVERIES Y EXTRAS)
-- ==========================================================

function GetVehicleLiveries(vehicle)
    local liveries = {}
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

    local numMods = GetNumVehicleMods(vehicle, 48)
    if numMods > 0 then
        for i = 0, numMods - 1 do
            table.insert(liveries, {
                id = i,
                type = "mod",
                name = "Design " .. (i + 1)
            })
        end
    end

    if numLiveries == 0 and numMods == 0 then
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

function ApplyVehicleLivery(vehicle, liveryData)
    if liveryData.type == "normal" then
        SetVehicleLivery(vehicle, liveryData.id)
    elseif liveryData.type == "mod" then
        SetVehicleMod(vehicle, 48, liveryData.id, true)
    elseif liveryData.type == "variation" then
        if DoesExtraExist(vehicle, liveryData.id) then
            SetVehicleExtra(vehicle, liveryData.id, 0)
        end
    end
    ForceVehicleUpdate(vehicle)
    Citizen.Wait(100)
    if liveryData.type == "normal" then
        SetVehicleLivery(vehicle, liveryData.id)
    elseif liveryData.type == "mod" then
        SetVehicleMod(vehicle, 48, liveryData.id, true)
    end
end

function ForceVehicleUpdate(vehicle)
    if not DoesEntityExist(vehicle) then
        return
    end
    local health = GetVehicleEngineHealth(vehicle)
    local dirtLevel = GetVehicleDirtLevel(vehicle)
    SetVehicleFixed(vehicle)
    Citizen.Wait(50)
    SetVehicleEngineHealth(vehicle, health)
    SetVehicleBodyHealth(vehicle, health)
    SetVehicleDirtLevel(vehicle, dirtLevel)
end

function ToggleExtra(extraId, currentState)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle == 0 then
        return false
    end

    local newState = not currentState
    local extraValue = newState and 0 or 1
    local progressText = newState and Config.Texts.applyingExtra or Config.Texts.removingExtra

    ExecuteProgressBar(progressText, Config.ProgressTimes.extra, function()
        SetVehicleExtra(vehicle, extraId, extraValue)
        ForceVehicleUpdate(vehicle)
        Citizen.Wait(100)
        SetVehicleExtra(vehicle, extraId, extraValue)

        local message = newState and Config.Texts.extraEnabled or Config.Texts.extraDisabled
        QBCore.Functions.Notify(message:gsub("{extraId}", extraId), 'success')

        if currentMenu == "extras" then
            Citizen.Wait(100)
            OpenExtrasMenu()
        end
    end)
    return newState
end

function ChangeLivery(liveryData)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle == 0 then
        return
    end

    ExecuteProgressBar(Config.Texts.applyingLivery, Config.ProgressTimes.livery, function()
        ApplyVehicleLivery(vehicle, liveryData)
        local message = Config.Texts.liveryChanged:gsub("{liveryId}", liveryData.name)
        QBCore.Functions.Notify(message, 'success')
        if currentMenu == "livery" then
            Citizen.Wait(100)
            OpenLiveryMenu()
        end
    end)
end

function ExecuteProgressBar(label, time, callback)
    QBCore.Functions.Progressbar("dp_extras_progress", label, time, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true
    }, {}, {}, {}, function()
        if callback then
            callback()
        end
    end, function()
        QBCore.Functions.Notify("Cancelado", "error")
    end)
end

-- ==========================================================
-- MENÚS
-- ==========================================================

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

function OpenLiveryMenu()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle == 0 then
        return
    end

    local menu = {{
        header = Config.Texts.liveriesTitle,
        isMenuHeader = true
    }}
    local liveries = GetVehicleLiveries(vehicle)
    local currentLivery = GetVehicleLivery(vehicle)
    local currentMod = GetVehicleMod(vehicle, 48)

    if #liveries > 0 then
        for _, livery in ipairs(liveries) do
            local isSelected = (livery.type == "normal" and currentLivery == livery.id) or
                                   (livery.type == "mod" and currentMod == livery.id)
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

-- ==========================================================
-- EVENTOS
-- ==========================================================

RegisterNetEvent('dp-extras:toggleExtra', function(data)
    ToggleExtra(data.extraId, data.currentState)
end)
RegisterNetEvent('dp-extras:setLivery', function(data)
    ChangeLivery(data.liveryData)
end)
RegisterNetEvent('dp-extras:openMainMenu', OpenVehicleMenu)
RegisterNetEvent('dp-extras:openLiveryMenu', OpenLiveryMenu)
RegisterNetEvent('dp-extras:openExtrasMenu', OpenExtrasMenu)

RegisterNetEvent('dp-extras:cleanVehicle', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle == 0 then
        return
    end
    ExecuteProgressBar(Config.Texts.washing, Config.ProgressTimes.wash, function()
        SetVehicleDirtLevel(vehicle, 0.0)
        QBCore.Functions.Notify(Config.Texts.washed, 'success')
        Citizen.Wait(300)
        OpenVehicleMenu()
    end)
end)

RegisterNetEvent('dp-extras:repairVehicle', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle == 0 then
        return
    end
    ExecuteProgressBar(Config.Texts.repairing, Config.ProgressTimes.repair, function()
        SetVehicleEngineHealth(vehicle, 1000.0)
        SetVehicleBodyHealth(vehicle, 1000.0)
        SetVehicleFixed(vehicle)
        QBCore.Functions.Notify(Config.Texts.repaired, 'success')
        Citizen.Wait(300)
        OpenVehicleMenu()
    end)
end)

-- ==========================================================
-- BUCLE PRINCIPAL (OPTIMIZADO)
-- ==========================================================

Citizen.CreateThread(function()
    while true do
        local wait = 1000 -- Por defecto, duerme 1 segundo (ahorra CPU)

        -- Verificar si tiene el trabajo requerido (o si no se requiere job)
        if not Config.JobRequired or (PlayerJob.name == Config.JobRequired) then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local distance = #(playerCoords - Config.Marker.position)

            -- Si está cerca, cambiamos el wait a 0 para dibujar fluido
            if distance < Config.Marker.drawDistance then
                wait = 0
                DrawMarker(Config.Marker.type, Config.Marker.position.x, Config.Marker.position.y,
                    Config.Marker.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Marker.size.x, Config.Marker.size.y,
                    Config.Marker.size.z, Config.Marker.color.r, Config.Marker.color.g, Config.Marker.color.b,
                    Config.Marker.color.a, Config.Marker.saltos, Config.Marker.sigue, false, Config.Marker.rotacion,
                    false, false, false)

                if distance < Config.Marker.interactionDistance then
                    if not inZone then
                        inZone = true
                        ShowTextUI(Config.Texts.drawText)
                    end

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
                        HideTextUI()
                    end
                end
            else
                -- Si se aleja pero estaba en zona, limpiamos UI
                if inZone then
                    inZone = false
                    HideTextUI()
                end
            end
        else
            -- Si cambia de trabajo y estaba en zona, limpiamos
            if inZone then
                inZone = false
                HideTextUI()
            end
        end

        Citizen.Wait(wait) -- Usamos el tiempo variable
    end
end)
