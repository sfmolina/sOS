------------------------------
--  AUTOR:       @sfmolina  --
--  Versión:     v1         --
--  Modificado:  26jun24    --
------------------------------


--- IMPORTS --------------------------------------------------------------------

local graficos  = dofile("sOS/sistema/graficos.lua")


--- ATRIBUTOS ------------------------------------------------------------------


local programas = {}


--- FUNCIONES ------------------------------------------------------------------


function programas.sosDia(salidas)

    local destino = 19

    graficos.escribirTexto(salidas, "Enviando señal de SOS a la estación meteorológica...")

    peripheral.find("modem", rednet.open)


    rednet.send(destino, "DE_DIA")


    peripheral.find("modem", rednet.close)

end


function programas.sosNoche(salidas)

    local destino = 19

    graficos.escribirTexto(salidas, "Enviando señal de SOS a la estación meteorológica...")

    peripheral.find("modem", rednet.open)


    rednet.send(destino, "DE_NOCHE")


    peripheral.find("modem", rednet.close)

end


function programas.sosDesp(salidas)

    local destino = 19

    graficos.escribirTexto(salidas, "Enviando señal de SOS a la estación meteorológica despejada")

    peripheral.find("modem", rednet.open)


    rednet.send(destino, "DE_DESPEJADO")


    peripheral.find("modem", rednet.close)

end


function programas.sosTorm(salidas)

    local destino = 19

    graficos.escribirTexto(salidas, "Enviando señal de SOS a la estación meteorológica...")

    peripheral.find("modem", rednet.open)


    rednet.send(destino, "DE_TORMENTA")


    peripheral.find("modem", rednet.close)

end


return programas
