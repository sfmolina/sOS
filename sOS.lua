------------------------------
--  AUTOR:       @sfmolina  --
--  Versión:     v1         --
--  Modificado:  26jun24    --
------------------------------



--- FUNCIONES ------------------------------------------------------------------



--- IMPORTS --------------------------------------------------------------------


local graficos      = dofile("sOS/sistema/graficos.lua")
local pantallas     = dofile("sOS/sistema/pantallas.lua")
local perifericos   = dofile("sOS/sistema/perifericos.lua")
local control       = dofile("sOS/sistema/control.lua")
local instalacion   = dofile("sOS/sistema/instalacion.lua")


--- ATRIBUTOS ------------------------------------------------------------------


local salidaTexto = {term}                     -- Salida de texto, por defecto la terminal
local salidaAudio = {}
local colorDefecto = control.getConfig("COLORD_TEXTO")   -- Color por defecto de la salida de texto


--- MAIN -----------------------------------------------------------------------


if not instalacion.estaInstalado() then

    instalacion.instalar()

end


graficos.limpiarPantallas(salidaTexto)
graficos.colorear(salidaTexto, colorDefecto)
graficos.escribirTextoLN(salidaTexto, "Bienvenido a sOS")


control.dormir()


-- Configurar perifericos, por ahora solo hay sopote para monitores (v1)
perifericos.configurarPerfifericos(salidaTexto, salidaAudio)


control.dormir()


graficos.escribirTextoLN(salidaTexto, "Iniciando sistema...")


control.dormir()


if not control.getConfig("SESION_INICIADA") then

    pantallas.inicioSesion(salidaTexto)

end


control.dormir()


graficos.escribirTextoLN(salidaTexto, "Sistema iniciado")


control.dormir()


pantallas.bienvenida(salidaTexto)


control.dormir(0.5)

while true do

    pantallas.inicio(salidaTexto)

end
