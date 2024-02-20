------------------------------
--  AUTOR:       @sfmolina  --
--  Versión:     v1         --
--  Modificado:  14feb24    --
------------------------------



--- IMPORTS --------------------------------------------------------------------


dofile("sOS/graficos.lua")
dofile("sOS/configuracion.lua")
dofile("sOS/animaciones.lua")
dofile("sOS/apps/indexaApps.lua")
dofile("sOS/botones/indexaBotones.lua")
dofile("sOS/interacciones.lua")



--- ATRIBUTOS ------------------------------------------------------------------


local pantallas = {}



--- FUNCIONES ------------------------------------------------------------------


function pantallas.inicioSesion(salidaTexto)

    limpiarPantallas(salidaTexto)

    --textoGrande(salidaTexto)
    escribirTextoLN(salidaTexto, "sOS")

    sleep(0.05)

    escribirTextoLN(salidaTexto, "--- Personalizacion ---")

    --textoNormal(salidaTexto)
    escribirTextoLN(salidaTexto, "Introduzca su nombre de usuario para personalizar su experiencia.")
    
    -- Preguntar por el nombre de usuario, y si está de acuerdo con el nombre introducido
    local aceptar = false
    while not aceptar do
        escribirTextoLN(salidaTexto, "")
        escribirTexto(salidaTexto, "Usuario: ")
        local usuario = io.read()
        local afirmativo = preguntarYN(salidaTexto, "De acuerdo con su nombre?")
        if afirmativo then
            setConfig("NOMBRE_USUARIO", usuario)
            setConfig("SESION_INICIADA", true)
            aceptar = true
        end
    end

end


function pantallas.bienvenida(salidaTexto)

    limpiarPantallas(salidaTexto)

    escribirTextoLN(salidaTexto, "")
    escribirTextoLN(salidaTexto, "")
    centrarTextoX(salidaTexto, "sOS")
    escribirTextoLN(salidaTexto, "sOS")
    centrarTextoX(salidaTexto, "---")
    escribirTextoLN(salidaTexto, "---")
    local nombre = getConfig("NOMBRE_USUARIO")
    centrarTextoX(salidaTexto, "Bienvenido, " .. nombre)
    escribirTextoLN(salidaTexto, "Bienvenido, " .. nombre)
    escribirTextoLN(salidaTexto, "")

    local routines = {}
    for _, salida in ipairs(salidaTexto) do
        table.insert(routines, function()
            local xPos, yPos = salida.getCursorPos()
            local xSize, _ = salida.getSize()
            barraEspera1(salida, 2, (xSize-10), xPos, yPos)
        end)
    end
    
    parallel.waitForAll(table.unpack(routines))

end


function pantallas.inicio(salidaTexto)

    limpiarPantallas(salidaTexto)

    local fecha = os.date("%d/%b/%y")

    escribirTextoLN(salidaTexto, "")
    escribirTexto(salidaTexto, "sOS")
    centrarTextoX(salidaTexto, fecha)
    escribirTextoLN(salidaTexto, "" .. fecha)

    centrarY(salidaTexto)

    for _, salida in ipairs(salidaTexto) do

        if(salida == term) then
            salida = term.current()
        end
        
        local xCursor, yCursor = salida.getCursorPos()
        local xSize, ySize = salida.getSize()

        -- +2 ó +1 porque porque las dos primeras lineas son para el titulo
        -- Ahora está centrado dos lineas más abajo del centro de la pantalla
        salida.setCursorPos(1, yCursor+1)

        xCursor, yCursor = salida.getCursorPos()

        local ventanaIzq = window.create(salida, 1, yCursor-4, 10, 11)
        local ventanaDer = window.create(salida, xSize-9, yCursor-4, 10, 11)

        ventanaIzq.setBackgroundColor(colors.gray)
        ventanaDer.setBackgroundColor(colors.gray)

        ventanaIzq.clear()
        ventanaDer.clear()

        encuadrarVentana1(ventanaIzq, true)
        encuadrarVentana1(ventanaDer, false, true)

        local xCursorVDer, yCursorVDer = ventanaDer.getCursorPos()
        local xCursorVIzq, yCursorVIzq = ventanaIzq.getCursorPos()

        ventanaIzq.setCursorPos(xCursorVIzq, yCursorVIzq+2)
        local favoritos = obtenerFavoritos()
        for app, _ in pairs(favoritos) do
            
            xCursor, yCursor = term.current().getCursorPos()

            setBotonPanel("INICIO_PANEL_IZQUIERDO", app, xCursor, yCursor)

            escribirTextoLN({ventanaIzq}, app)
            escribirTextoLN({ventanaIzq}, "")

        end

        if salida == term.current() then
            local app, click, panel, x, y = clickBoton()
    
            if (app ~= nil) and (click == 1) then
                pantallas.pruebaTexto(salidaTexto, "Click en " .. app .. " del panel " .. panel)
            else
                pantallas.pruebaTexto(salidaTexto, "Click en " .. x .. ", " .. y)
            end
        end


        salida.setCursorPos(1, 2)


    end

end


function pantallas.pruebaTexto(salidaTexto, texto)

    limpiarPantallas(salidaTexto)

    escribirTextoLN(salidaTexto, texto)

end


return pantallas
