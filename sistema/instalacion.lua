------------------------------
--  AUTOR:       @sfmolina  --
--  Versión:     v1         --
--  Modificado:  26jun24    --
------------------------------



--- IMPORTS --------------------------------------------------------------------


local control = dofile("sOS/sistema/control.lua")


-- ATRIBUTOS -------------------------------------------------------------------


local instalacion = {}


--- FUNCIONES ------------------------------------------------------------------


function instalacion.estaInstalado()

    local exito, resultado = pcall(control.getConfig, "VERSION_SOS")
    return exito

end


function instalacion.instalar()

    local direccion = "sOS/sistema/configuracion/configuracion.lua"

    local file = io.open(direccion, "w")  -- Abre el archivo en modo de escritura

    local st = control.serializeTable({
        TAM_TEXTO_GRANDE = 1,
        TAM_TEXTO = 0.5,
        COLORD_TEXTO = 1,
        NOMBRE_USUARIO = "",
        SESION_INICIADA = false,
        TIPO_COMPUTADOR = 0,
        VERSION_SOS = "1",
    }, "config")

    st = "local " .. st
    
    st = st .. "\n return config"

    file:write(st)
    file:close()  -- Cierra el archivo

end


return instalacion
