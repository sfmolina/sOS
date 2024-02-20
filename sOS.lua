------------------------------
--  AUTOR:       @sfmolina  --
--  Versión:     v1         --
--  Modificado:  14feb24    --
------------------------------



--- FUNCIONES ------------------------------------------------------------------



--- IMPORTS --------------------------------------------------------------------


dofile("sOS/graficos.lua")
local pantallas = dofile("sOS/pantallas.lua")
local perifericos = dofile("sOS/perifericos.lua")
dofile("sOS/configuracion.lua") -- Cargar configuracion, variables en mayusculas y snake_case




--- ATRIBUTOS ------------------------------------------------------------------


local salidaTexto = {term}                     -- Salida de texto, por defecto la terminal
local salidaAudio = {}
local colorDefecto = getConfig("COLORD_TEXTO")   -- Color por defecto de la salida de texto



--- MAIN -----------------------------------------------------------------------


limpiarPantallas(salidaTexto)
colorear(salidaTexto, colorDefecto)
escribirTextoLN(salidaTexto, "Bienvenido a sOS")


dormirDefecto()


-- Configurar perifericos, por ahora solo hay sopote para monitores (v1)
perifericos.configurarPerfifericos(salidaTexto, salidaAudio)


dormirDefecto()


escribirTextoLN(salidaTexto, "Iniciando sistema...")


dormirDefecto()


if not getConfig("SESION_INICIADA") then

    pantallas.inicioSesion(salidaTexto)

end


dormirDefecto()


escribirTextoLN(salidaTexto, "Sistema iniciado")


dormirDefecto()


pantallas.bienvenida(salidaTexto)


sleep(0.5)


pantallas.inicio(salidaTexto)
