------------------------------
--  AUTOR:       @sfmolina  --
--  Versión:     v1         --
--  Modificado:  14feb24    --
------------------------------



function obtenerFavoritos()

    return dofile("sOS/apps/favoritos.lua")

end


function obtenerAplicaciones()

    return dofile("sOS/apps/aplicaciones.lua")

end


function estaEnFavoritos(app)

    local favoritos = obtenerFavoritos()
    return favoritos[app]

end


function estaInstalada(app)

    local aplicaciones = obtenerAplicaciones()
    return aplicaciones[app]

end
