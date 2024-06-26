------------------------------
--  AUTOR:       @sfmolina  --
--  Versión:     v1         --
--  Modificado:  26jun24    --
------------------------------



--- IMPORTS --------------------------------------------------------------------


local control       = dofile("sOS/sistema/control.lua")
local graficos      = dofile("sOS/sistema/graficos.lua")
local animaciones   = dofile("sOS/sistema/animaciones.lua")
local indexaApps    = dofile("sOS/apps/indexaApps.lua")
local indexaBotones = dofile("sOS/botones/indexaBotones.lua")
local interacciones = dofile("sOS/sistema/interacciones.lua")



--- ATRIBUTOS ------------------------------------------------------------------


local pantallas = {}


--- FUNCIONES ------------------------------------------------------------------


function pantallas.inicioSesion(salidaTexto)

    graficos.limpiarPantallas(salidaTexto)

    --textoGrande(salidaTexto)
    graficos.escribirTextoLN(salidaTexto, "sOS")

    control.dormir(0.05)

    graficos.escribirTextoLN(salidaTexto, "--- Personalizacion ---")

    --textoNormal(salidaTexto)
    graficos.escribirTextoLN(salidaTexto, "Introduzca su nombre de usuario para personalizar su experiencia.")
    
    -- Preguntar por el nombre de usuario, y si está de acuerdo con el nombre introducido
    local aceptar = false
    while not aceptar do
        graficos.escribirTextoLN(salidaTexto, "")
        graficos.escribirTexto(salidaTexto, "Usuario: ")
        local usuario = io.read()
        local afirmativo = graficos.preguntarYN(salidaTexto, "De acuerdo con su nombre?")
        if afirmativo then
            control.setConfig("NOMBRE_USUARIO", usuario)
            control.setConfig("SESION_INICIADA", true)
            aceptar = true
        end
    end

end


function pantallas.bienvenida(salidaTexto)

    graficos.limpiarPantallas(salidaTexto)

    graficos.escribirTextoLN(salidaTexto, "")
    graficos.escribirTextoLN(salidaTexto, "")
    graficos.centrarTextoX(salidaTexto, "sOS")
    graficos.escribirTextoLN(salidaTexto, "sOS")
    graficos.centrarTextoX(salidaTexto, "---")
    graficos.escribirTextoLN(salidaTexto, "---")
    local nombre = control.getConfig("NOMBRE_USUARIO")
    graficos.centrarTextoX(salidaTexto, "Bienvenido, " .. nombre)
    graficos.escribirTextoLN(salidaTexto, "Bienvenido, " .. nombre)
    graficos.escribirTextoLN(salidaTexto, "")

    local routines = {}
    for _, salida in ipairs(salidaTexto) do
        table.insert(
            routines,
            function()
                local xPos, yPos = salida.getCursorPos()
                local xSize, _ = salida.getSize()
                animaciones.barraEspera1(salida, 2, (xSize-10), xPos, yPos)
            end
        )
    end
    
    parallel.waitForAll(table.unpack(routines))

end


function pantallas.inicio(salidaTexto)

    local salidaPrincipal = term.current()

    graficos.limpiarPantallas(salidaTexto)

    local fecha = os.date("%d/%b/%y")

    graficos.escribirTextoLN(salidaTexto, "")
    graficos.escribirTexto(salidaTexto, "sOS")
    graficos.centrarTextoX(salidaTexto, fecha)
    graficos.escribirTextoLN(salidaTexto, "" .. fecha)

    graficos.centrarY(salidaTexto)

    local routines = {}

    for _, salida in ipairs(salidaTexto) do

        table.insert(
            routines,
            function()

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
        
                graficos.encuadrarVentana1(ventanaIzq, true)
                graficos.encuadrarVentana1(ventanaDer, false, true)
        
                local xCursorVDer, yCursorVDer = ventanaDer.getCursorPos()
                local xCursorVIzq, yCursorVIzq = ventanaIzq.getCursorPos()
        
                ventanaIzq.setCursorPos(xCursorVIzq, yCursorVIzq+2)
                local favoritos = indexaApps.obtenerFavoritos()
                for app, _ in pairs(favoritos) do
                    
                    xCursor, yCursor = term.current().getCursorPos()
        
                    indexaBotones.setBotonPanel("INICIO_PANEL_IZQUIERDO", app, xCursor, yCursor)
        
                    graficos.escribirTextoLN({ventanaIzq}, app)
                    graficos.escribirTextoLN({ventanaIzq}, "")
        
                end

            end
        )

    end

    parallel.waitForAll(table.unpack(routines))


    -- Probando la interacción con los botones
    -- Esto debería en un futuro ejecutar la aplicación correspondiente
    local event, button, x, y = interacciones.click()
    local app, panel = indexaBotones.botonPanelPulsado(x, y)

    if (app ~= nil) then
        control.ejecutar(app, salidaTexto)
    else
        pantallas.pruebaTexto(salidaTexto, "Click en " .. x .. ", " .. y)
    end

    salidaPrincipal.setCursorPos(1, 2)

end


function pantallas.pruebaTexto(salidaTexto, texto)

    graficos.limpiarPantallas(salidaTexto)

    graficos.escribirTextoLN(salidaTexto, texto)

end


return pantallas
