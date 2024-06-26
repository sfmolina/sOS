------------------------------
--  AUTOR:       @sfmolina  --
--  Versión:     v1         --
--  Modificado:  26jun24    --
------------------------------



--- IMPORTS --------------------------------------------------------------------



--- ATRIBUTOS ------------------------------------------------------------------


local control = {}


--- FUNCIONES ------------------------------------------------------------------


--- Esta función es un simple sleep que determina una velocidad mínima para el SO
--- de manera que el usuario pueda leer los mensajes (que no suelen ser importantes).
function control.dormir(tiempo)
    tiempo = tiempo or 0.2
    sleep(tiempo)
end


function control.serializeTable(val, name, skipnewlines, depth)

    skipnewlines = skipnewlines or false
    depth = depth or 0

    local tmp = string.rep(" ", depth)

    if name then

        if type(name) == "number" then
            name = "[" .. name .. "]"
        end

        tmp = tmp .. name .. " = "

    end

    if type(val) == "table" then
        tmp = tmp .. "{" .. (not skipnewlines and "\n" or "")

        for k, v in pairs(val) do
            tmp =  tmp .. control.serializeTable(v, k, skipnewlines, depth + 1) .. "," .. (not skipnewlines and "\n" or "")
        end

        tmp = tmp .. string.rep(" ", depth) .. "}"
    elseif type(val) == "number" then
        tmp = tmp .. tostring(val)
    elseif type(val) == "string" then
        tmp = tmp .. string.format("%q", val)
    elseif type(val) == "boolean" then
        tmp = tmp .. (val and "true" or "false")
    else
        tmp = tmp .. "\"[inserializeable datatype:" .. type(val) .. "]\""
    end

    return tmp

end


function control.getConfig(nombreVariable)
    local config = dofile("sOS/sistema/configuracion/configuracion.lua")
    return config[nombreVariable]
end


-- DEPRECATED !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--
-- function control.refrescarConfig()
--     dofile("sOS/configuracion.lua")
-- end


function control.setConfig(nombreVariable, valor)

    local direccion = "sOS/sistema/configuracion/configuracion.lua"
    
    -- Modifica la variable en la configuración
    local config = dofile(direccion)
    config[nombreVariable] = valor


    -- Abre el archivo
    local file = io.open(direccion, "w")

    -- Prepara la nueva configuración para ser escrita
    local st = control.serializeTable(config, "config")
    st = "local " .. st
    st = st .. "\n return config"

    -- Escribe la nueva configuración
    file:write(st)

    -- Cierra el archivo
    file:close()  

    -- local contenido = f:read("*all")
    -- f:close()

    -- -- Comprobar el tipo de valor
    -- local valorStr
    -- if type(valor) == "boolean" or type(valor) == "number" then
    --     valorStr = tostring(valor)
    -- else
    --     valorStr = "\"" .. valor .. "\""
    -- end

    -- -- Reemplazar el valor de la variable
    -- contenido = contenido:gsub(nombreVariable .. " =.-\n", nombreVariable .. " = " .. valorStr .. "," .. "\n")

    -- -- Escribir de nuevo en el archivo
    -- f = io.open("sOS/configuracion.lua", "w")
    -- f:write(contenido)
    -- f:close()

end


function control.ejecutar(nombre, salidas)
    local programas = dofile("sOS/apps/programas.lua")
    programas[nombre](salidas)
end


return control
