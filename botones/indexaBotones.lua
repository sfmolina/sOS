------------------------------
--  AUTOR:       @sfmolina  --
--  Versión:     v1         --
--  Modificado:  26jun24    --
------------------------------



--- IMPORTS --------------------------------------------------------------------


local control = dofile("sOS/sistema/control.lua")


-- ATRIBUTOS -------------------------------------------------------------------


local indexaBotones = {}



--- FUNCIONES ------------------------------------------------------------------


local function guardarBotones(tabla, nombrePanel)

    local direccion = "sOS/botones/" .. nombrePanel .. ".lua"

    local file = io.open(direccion, "w")  -- Abre el archivo en modo de escritura

    local st = control.serializeTable(tabla, "botones")

    st = "local " .. st

    st = st .. "\n return botones"

    file:write(st)

    file:close()  -- Cierra el archivo


    -- Actualiza la lista completa de botones (paneles)

    local listaBotones = indexaBotones.getListaBotones()

    local posPanel = #listaBotones+1
    for k, v in pairs(listaBotones) do
        if v == nombrePanel then
            posPanel = k
            break
        end
    end

    listaBotones[posPanel] = nombrePanel

    file = io.open("sOS/botones/listaBotones.lua", "w")  -- Abre el archivo en modo de escritura

    st = control.serializeTable(listaBotones, "paneles")

    st = "local " .. st

    st = st .. "\n return paneles"

    file:write(st)

    file:close()  -- Cierra el archivo

end


function indexaBotones.setBotonPanel(nombrePanel, nombreBoton, x, y)

    local botones = indexaBotones.getBotonesPanel(nombrePanel)

    -- Si no existe el botón, lo crea
    -- Si existe, lo actualiza

    local boton = #botones+1
    for k, v in pairs(botones) do
        if v["nombre"] == nombreBoton then
            boton = k
            break
        end
    end

    botones[boton] = {
        nombre = nombreBoton,
        x = x,
        y = y,
        tam = #nombreBoton,
    }

    guardarBotones(botones, nombrePanel)

end


function indexaBotones.getBotonesPanel(nombrePanel)

    local direccion = "sOS/botones/" .. nombrePanel .. ".lua"

    local exito, botones = pcall(dofile, direccion)
    if not exito then
        botones = {}
    end

    return botones

end


function indexaBotones.getListaBotones()

    local exito, paneles = pcall(dofile, "sOS/botones/listaBotones.lua")
    if not exito then
        paneles = {}
    end

    return paneles

end


-- HAY UN BUG: SI HAY UN MONITOR CONECTADO NO DEVUELVE EL NOMBRE DE LA APP
function indexaBotones.botonPanelPulsado(x, y)

    local paneles = indexaBotones.getListaBotones()

    for _, panel in pairs(paneles) do
        local botones = indexaBotones.getBotonesPanel(panel)
        for _, boton in pairs(botones) do

            if (y == boton.y) and (boton.x <= x and x <= boton.tam) then
                return boton.nombre, panel
            end

        end
    end

    return nil, nil

end


return indexaBotones
