------------------------------
--  AUTOR:       @sfmolina  --
--  Versión:     v1         --
--  Modificado:  26jun24    --
------------------------------



--- IMPORTS --------------------------------------------------------------------



--- ATRIBUTOS ------------------------------------------------------------------


local indexaApps = {}


--- FUNCIONES ------------------------------------------------------------------


function indexaApps.obtenerFavoritos()

    return dofile("sOS/apps/favoritos.lua")

end


function indexaApps.obtenerAplicaciones()

    return dofile("sOS/apps/aplicaciones.lua")

end


function indexaApps.estaEnFavoritos(app)

    local favoritos = indexaApps.obtenerFavoritos()
    return favoritos[app]

end


function indexaApps.estaInstalada(app)

    local aplicaciones = indexaApps.obtenerAplicaciones()
    return aplicaciones[app]

end


return indexaApps
