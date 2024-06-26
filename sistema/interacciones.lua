------------------------------
--  AUTOR:       @sfmolina  --
--  Versión:     v1         --
--  Modificado:  26jun24    --
------------------------------



--- IMPORTS --------------------------------------------------------------------


local indexaBotones = dofile("sOS/botones/indexaBotones.lua")
local control       = dofile("sOS/sistema/control.lua")


-- ATRIBUTOS -------------------------------------------------------------------


local interacciones = {}


--- FUNCIONES ------------------------------------------------------------------


function interacciones.click()

    local event, button, x, y = os.pullEvent("mouse_click")

    -- local paneles = indexaBotones.getListaBotones()

    -- for _, panel in pairs(paneles) do
    --     local botones = indexaBotones.getBotonesPanel(panel)
    --     for _, boton in pairs(botones) do

    --         if (y == boton.y) and (boton.x <= x and x <= boton.tam) then
    --             return boton.nombre, button, panel, x, y
    --         end

    --     end
    -- end

    return event, button, x, y

end


return interacciones
