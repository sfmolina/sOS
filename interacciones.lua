------------------------------
--  AUTOR:       @sfmolina  --
--  Versión:     v1         --
--  Modificado:  14feb24    --
------------------------------



--- IMPORTS --------------------------------------------------------------------


dofile("sOS/configuracion.lua")
dofile("sOS/botones/indexaBotones.lua")



--- FUNCIONES ------------------------------------------------------------------


function clickBoton()

    local event, button, x, y = os.pullEvent("mouse_click")

    local paneles = getListaBotones()

    for _, panel in pairs(paneles) do
        local botones = getBotonesPanel(panel)
        for _, boton in pairs(botones) do

            if (y == boton.y) and (boton.x <= x and x <= boton.tam) then
                return boton.nombre, button, panel, x, y
            end

        end
    end

    return nil, nil, nil, x, y

end
