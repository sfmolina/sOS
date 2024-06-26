------------------------------
--  AUTOR:       @sfmolina  --
--  Versión:     v1         --
--  Modificado:  26jun24    --
------------------------------



--- IMPORTS --------------------------------------------------------------------


local graficos  = dofile("sOS/sistema/graficos.lua")
local control   = dofile("sOS/sistema/control.lua")


--- ATRIBUTOS ------------------------------------------------------------------


local perifericos = {}

if control.getConfig("TIPO_COMPUTADOR") == 1 then
    
    perifericos.monitor = { peripheral.find("monitor") }
    perifericos.hayMonitor = #perifericos.monitor ~= 0

end

perifericos.altavoz = { peripheral.find("speaker") }
perifericos.hayAltavoz = #perifericos.altavoz ~= 0


--- FUNCIONES ------------------------------------------------------------------


function perifericos.estadoConexion(estaConectado, nombreDispositivo, salidas)

    if estaConectado then
        graficos.colorear(salidas, colors.green)
        graficos.escribirTextoLN(salidas, nombreDispositivo .. " conectado")
    else
        graficos.colorear(salidas, colors.red)
        graficos.escribirTextoLN(salidas, nombreDispositivo .. " no conectado")
    end

    graficos.colorear(salidas, control.getConfig("COLORD_TEXTO"))

end


function perifericos.configurarPerfifericos(salidaTexto, salidaAudio)

    graficos.escribirTextoLN(salidaTexto, "Comprobando perifericos...")


    control.dormir()


    -- Si hay monitorres, se agregan a la salida de texto para que se imprima en los monitores tambien
    -- También los configura con el tamaño de texto por defecto
    -- Lo hace usando ventanas
    if perifericos.hayMonitor then

        for _, m in ipairs(perifericos.monitor) do

            local xSize, ySize = m.getSize()
            local mw = window.create(m, 1, 1, xSize, ySize)

            table.insert(salidaTexto, mw)

            mw.clear()
            local escala = control.getConfig("TAM_TEXTO")
            m.setTextScale(escala)
            mw.setCursorPos(1, 1)

        end

    end


    if control.getConfig("TIPO_COMPUTADOR") == 1 then

        perifericos.estadoConexion(perifericos.hayMonitor, "Monitor", salidaTexto)
        
    end


    control.dormir()


    if perifericos.hayAltavoz then

        for _, a in ipairs(perifericos.altavoz) do
            table.insert(salidaAudio, a)
            a.playNote("xylophone")
        end

    end

    perifericos.estadoConexion(perifericos.hayAltavoz, "Altavoz", salidaTexto)

end


return perifericos
