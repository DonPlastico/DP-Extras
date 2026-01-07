Config = {}

-- Configuración de coordenadas y marker
Config.Marker = {
    type = 20, -- Tipo de marker (ver https://docs.fivem.net/docs/game-references/markers/)
    size = vector3(0.3, 0.3, 0.3), -- Tamaño del marker
    color = {r = 0, g = 0, b = 0, a = 255}, -- Color RGBA del marker
    position = vector3(461.87, -1016.78, 27.70), -- Cambia estas coordenadas a las que desees
    saltos = false, -- true = El marker tiene efecto de saltos, false = no tiene efecto
    sigue = false, -- true = El marker siempre mira a la camara, false = no lo hace
    rotacion = true, -- true = El marker siempre gira sobre si mismo, false = no lo hace
    drawDistance = 10.0, -- Distancia a la que se ve el marker
    interactionDistance = 2.0 -- Distancia máxima para interactuar y que se cierre el menú
}

-- Configuración de jobs
Config.JobRequired = "police" -- Job requerido para usar el sistema, pon false para que cualquiera pueda usarlo

-- Sistema de texto a utilizar
Config.UseDPTextUI = true -- true = DP-TextUI, false = qb-core

-- Tiempos de progreso (en milisegundos)
Config.ProgressTimes = {
    wash = 5000, -- 5 segundos para lavar
    repair = 5000, -- 5 segundos para reparar
    extra = 1000, -- 1 segundos para extras
    livery = 1000 -- 1 segundos para liveries
}

-- Textos y traducciones
Config.Texts = {
    drawText = "Modificar vehículo", -- Texto que aparece al estar cerca del marker
    noVehicle = "Debes estar en un vehículo", -- Texto que aparece si no estás en un vehículo
    washed = "Vehículo lavado correctamente", -- Texto que aparece al lavar el vehículo
    repaired = "Vehículo reparado correctamente", -- Texto que aparece al reparar el vehículo
    extraEnabled = "Extra {extraId} activada", -- Texto que aparece al activar un extra
    extraDisabled = "Extra {extraId} desactivada", -- Texto que aparece al desactivar un extra
    liveryChanged = "Livery cambiado a: {liveryId}", -- Texto que aparece al cambiar un livery
    noLiveries = "Este vehículo no tiene liveries", -- Texto que aparece si el vehículo no tiene liveries
    noExtras = "Este vehículo no tiene extras", -- Texto que aparece si el vehículo no tiene extras

    -- Títulos de menús
    mainTitle = "OPCIONES DE VEHÍCULO", -- Título del menú principal
    liveriesTitle = "SELECCIONA UN LIVERY", -- Título del menú de liveries
    extrasTitle = "SELECCIONA UN EXTRA", -- Título del menú de extras

    -- Opciones de menú
    liveriesOption = "Cambiar calcomanías del vehículo", -- Opción para abrir el menú de liveries
    extrasOption = "Activar/Desactivar extras del vehículo", -- Opción para abrir el menú de extras
    washOption = "Limpiar el vehículo", -- Opción para lavar el vehículo
    repairOption = "Reparar el vehículo", -- Opción para reparar el vehículo
    backOption = "Volver", -- Opción para volver al menú anterior

    -- Textos de progreso
    washing = "Lavando vehículo...", -- Texto que aparece mientras se lava el vehículo
    repairing = "Reparando vehículo...", -- Texto que aparece mientras se repara el vehículo
    applyingExtra = "Aplicando extra...", -- Texto que aparece mientras se aplica un extra
    removingExtra = "Quitando extra...", -- Texto que aparece mientras se quita un extra
    applyingLivery = "Aplicando livery...", -- Texto que aparece mientras se aplica un livery

    -- Estados
    selected = "✓ SELECCIONADO", -- Texto que indica que un extra o livery está seleccionado
    clickToSelect = "Click para seleccionar", -- Texto que indica que se puede hacer click para seleccionar un extra o livery
    enabled = "🟢 ACTIVADA", -- Texto que indica si está el extra activado
    disabled = "🔴 DESACTIVADA" -- Texto que indica si está el extra desactivado
}

-- Iconos de Font Awesome
Config.Icons = {
    paintRoller = "fa-solid fa-paint-roller", -- Icono de rodillo de pintura
    gears = "fa-solid fa-gears", -- Icono de engranajes
    soap = "fa-solid fa-soap", -- Icono de jabón
    wrench = "fa-solid fa-wrench", -- Icono de llave inglesa
    back = "fa-solid fa-arrow-left", -- Icono de volver (flecha izquierda)
    paintBrush = "fa-solid fa-paint-brush", -- Icono de brocha de pintura
    toggleOn = "fa-solid fa-toggle-on", -- Icono de toggle on
    toggleOff = "fa-solid fa-toggle-off" -- Icono de toggle off
}
