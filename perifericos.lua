------------------------------
--  AUTOR:       @sfmolina  --
--  Versión:     v1         --
--  Modificado:  14feb24    --
------------------------------



--- IMPORTS --------------------------------------------------------------------


dofile("sOS/graficos.lua")
dofile("sOS/configuracion.lua")



--- ATRIBUTOS ------------------------------------------------------------------


local perifericos = {}

perifericos.monitor = { peripheral.find("monitor") }
perifericos.hayMonitor = #perifericos.monitor ~= 0

perifericos.altavoz = { peripheral.find("speaker") }
perifericos.hayAltavoz = #perifericos.altavoz ~= 0



--- FUNCIONES ------------------------------------------------------------------


function perifericos.estadoConexion(estaConectado, nombreDispositivo, salidas)

    if estaConectado then
        colorear(salidas, colors.green)
        escribirTextoLN(salidas, nombreDispositivo .. " conectado")
    else
        colorear(salidas, colors.red)
        escribirTextoLN(salidas, nombreDispositivo .. " no conectado")
    end

    colorear(salidas, getConfig("COLORD_TEXTO"))

end


function perifericos.configurarPerfifericos(salidaTexto, salidaAudio)

    escribirTextoLN(salidaTexto, "Comprobando perifericos...")


    dormirDefecto()


    -- Si hay monitorres, se agregan a la salida de texto para que se imprima en los monitores tambien
    -- También los configura con el tamaño de texto por defecto
    -- Lo hace usando ventanas
    if perifericos.hayMonitor then

        for _, m in ipairs(perifericos.monitor) do

            local xSize, ySize = m.getSize()
            local mw = window.create(m, 1, 1, xSize, ySize)

            table.insert(salidaTexto, mw)

            mw.clear()
            local escala = getConfig("TAM_TEXTO")
            m.setTextScale(escala)
            mw.setCursorPos(1, 1)

        end

    end

    perifericos.estadoConexion(perifericos.hayMonitor, "Monitor", salidaTexto)


    dormirDefecto()


    if perifericos.hayAltavoz then

        for _, a in ipairs(perifericos.altavoz) do
            table.insert(salidaAudio, a)
            a.playNote("xylophone")
        end

    end

    perifericos.estadoConexion(perifericos.hayAltavoz, "Altavoz", salidaTexto)

end


return perifericos
