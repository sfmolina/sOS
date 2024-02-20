------------------------------
--  AUTOR:       @sfmolina  --
--  Versión:     v1         --
--  Modificado:  14feb24    --
------------------------------



local config = {

    -- Version del sistema operativo
    VERSION_SOS = "1",

    -- Indica si la sesion esta iniciada
    SESION_INICIADA = true,

    -- Nombre del usuario
    NOMBRE_USUARIO = "Senbin",

    -- Tamaño del texto
    TAM_TEXTO = 0.5,

    -- Tamaño del texto grande
    TAM_TEXTO_GRANDE = 1,

    -- Color del texto
    COLORD_TEXTO = colors.white

}


function setConfig(nombreVariable, valor)
    
    -- Leer el archivo
    local f = io.open("sOS/configuracion.lua", "r")
    local contenido = f:read("*all")
    f:close()

    -- Comprobar el tipo de valor
    local valorStr
    if type(valor) == "boolean" or type(valor) == "number" then
        valorStr = tostring(valor)
    else
        valorStr = "\"" .. valor .. "\""
    end

    -- Reemplazar el valor de la variable
    contenido = contenido:gsub(nombreVariable .. " =.-\n", nombreVariable .. " = " .. valorStr .. "," .. "\n")

    -- Escribir de nuevo en el archivo
    f = io.open("sOS/configuracion.lua", "w")
    f:write(contenido)
    f:close()

end


function getConfig(nombreVariable)
    local config = dofile("sOS/configuracion.lua")
    return config[nombreVariable]
end


function refrescarConfig()
    dofile("sOS/configuracion.lua")
end


function serializeTable(val, name, skipnewlines, depth)
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
            tmp =  tmp .. serializeTable(v, k, skipnewlines, depth + 1) .. "," .. (not skipnewlines and "\n" or "")
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


return config
