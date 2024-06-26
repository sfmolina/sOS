------------------------------
--  AUTOR:       @sfmolina  --
--  Versión:     v1         --
--  Modificado:  26jun24    --
------------------------------



--- IMPORTS --------------------------------------------------------------------


--local graficos  = dofile("sOS/graficos.lua")
local control   = dofile("sOS/sistema/control.lua")


-- ATRIBUTOS -------------------------------------------------------------------


local animaciones = {}


--- FUNCIONES ------------------------------------------------------------------


-- Displays a progress bar animation on the screen.
--
-- Parameters:
--   - salida: The output terminal or window to display the progress bar.
--   - tiempo: The total time (in seconds) for the animation to complete.
--   - longitud: The length of the progress bar.
--   - x: The x-coordinate of the top-left corner of the progress bar.
--   - y: The y-coordinate of the top-left corner of the progress bar.
--
function animaciones.barraEspera1(salida, tiempo, longitud, x, y)

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
        control.dormir(espera)
        barra.setCursorPos(pos+i, yBSize)
        barra.write("=")
    end

end


return animaciones
