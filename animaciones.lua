------------------------------
--  AUTOR:       @sfmolina  --
--  Versión:     v1         --
--  Modificado:  14feb24    --
------------------------------



--- IMPORTS --------------------------------------------------------------------


dofile("sOS/graficos.lua")
dofile("sOS/configuracion.lua")



--- FUNCIONES ------------------------------------------------------------------


function barraEspera1(salida, tiempo, longitud, x, y)

    if salida == term then
        salida = term.current()
    end

    local progreso = "[" .. string.rep(" ", longitud) .. "]"
    local espera = (tiempo / longitud)

    local xSize, ySize = salida.getSize()
    local barra = window.create(salida, x, y, xSize, 1)

    local xBSeize, yBSize = barra.getSize()
    local pos = (xBSeize/2)-(#progreso/2)+1

    barra.setCursorPos(pos, yBSize)
    barra.write(progreso)

    for i = 1, longitud do
        sleep(espera)
        barra.setCursorPos(pos+i, yBSize)
        barra.write("=")
    end

end