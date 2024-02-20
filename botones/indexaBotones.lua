------------------------------
--  AUTOR:       @sfmolina  --
--  Versión:     v1         --
--  Modificado:  14feb24    --
------------------------------



local function guardarBotones(tabla, nombrePanel)

    local direccion = "sOS/botones/" .. nombrePanel .. ".lua"

    local file = io.open(direccion, "w")  -- Abre el archivo en modo de escritura

    local st = serializeTable(tabla, "botones")

    st = "local " .. st

    st = st .. "\n return botones"

    file:write(st)

    file:close()  -- Cierra el archivo


    -- Actualiza la lista completa de botones (paneles)

    local listaBotones = getListaBotones()

    local posPanel = #listaBotones+1
    for k, v in pairs(listaBotones) do
        if v == nombrePanel then
            posPanel = k
            break
        end
    end

    listaBotones[posPanel] = nombrePanel

    file = io.open("sOS/botones/listaBotones.lua", "w")  -- Abre el archivo en modo de escritura

    st = serializeTable(listaBotones, "paneles")

    st = "local " .. st

    st = st .. "\n return paneles"

    file:write(st)

    file:close()  -- Cierra el archivo

end


function setBotonPanel(nombrePanel, nombreBoton, x, y)

    local botones = getBotonesPanel(nombrePanel)

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


function getBotonesPanel(nombrePanel)

    local direccion = "sOS/botones/" .. nombrePanel .. ".lua"

    local exito, botones = pcall(dofile, direccion)
    if not exito then
        botones = {}
    end

    return botones

end


function getListaBotones()

    local exito, paneles = pcall(dofile, "sOS/botones/listaBotones.lua")
    if not exito then
        paneles = {}
    end

    return paneles

end
