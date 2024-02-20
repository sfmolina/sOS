------------------------------
--  AUTOR:       @sfmolina  --
--  Versión:     v1         --
--  Modificado:  14feb24    --
------------------------------



--- IMPORTS --------------------------------------------------------------------


dofile("sOS/configuracion.lua")



--- FUNCIONES ------------------------------------------------------------------


--- DEPRECATED
--- ############################################################################################
--- Calcula el factor de escala para un monitor en función de su tamaño y el número de aumentos.
--- Un monitor de 1 de ancho equivale a 0.5 de escala, uno de 2 a 0.5, uno de 3 a 0.5, uno de 4 a 1...
--- No se puede superar ni igualar el doble de la escala media de los monitores.
--- @param monitor Redirect El objeto del monitor.
--- @param aumentos number El número de aumentos.
--- @return number escala El factor de escala calculado (entre 0.5 y 5).
--- --------------------------------------
function calcularEscala(monitor, aumentos)

    local xTam, _ = monitor.getSize()
    print(xTam)

    local escalaMedia = (math.ceil(xTam / 3))/2

    local escala = escalaMedia + (0.5 * aumentos)


    while escala >= escalaMedia*2 do
        escala = escala - 0.5
    end


    escala = math.max(escala, 0.5)
    escala = math.min(escala, 5)

    return escala

end


--- Verifica la altura de la ventana de salida y la desplaza si es necesario.
--- La penúltima línea cuenta como la altura máxima.
--- @param salida Redirect Salida de texto a comprobar.
--- -----------------------------------
local function comprobarAltura(salida)

    local _, ySize = salida.getSize()
    local _, yCursor = salida.getCursorPos()

    if yCursor > ySize then
        salida.scroll(1)
    end

end


--- Divide el texto en líneas que no superen el ancho de las salidas.
--- @param salida Redirect Las salidas de texto en las que se va a escribir.
--- @param texto string El texto que se va a escribir.
--- @return table lineas Las líneas de texto divididas.
--- ------------------------------------
function comprobarAnchura(salida, texto)

    local lineas = {}
    local xSize, _ = salida.getSize()
    local xCursor, _ = salida.getCursorPos()

    local linea = ""
    for i = 1, #texto do

        local caracter = texto:sub(i, i)

        if xCursor + #linea > xSize then
            table.insert(lineas, linea)
            linea = ""
            xCursor = 1
        end

        if not (#linea == 0 and (caracter == " " or caracter == "\n")) then
            linea = linea .. caracter
        end

    end

    table.insert(lineas, linea)

    return lineas

end


--- Escribe el texto especificado en las salidas dadas.
--- Nunca escribe en la última línea de la salida.
--- @param salidas table Las salidas de texto en las que se va a escribir.
--- @param texto string El texto que se va a escribir.
--- ------------------------------------
function escribirTextoLN(salidas, texto)

    for _, salida in ipairs(salidas) do

        local lineas = comprobarAnchura(salida, texto)

        for _, linea in ipairs(lineas) do

            comprobarAltura(salida)

            salida.write(linea)

            local _, y = salida.getCursorPos()
            salida.setCursorPos(1, y + 1)

        end

    end

end

function escribirTexto(salidas, texto)

    for _, salida in ipairs(salidas) do

        local lineas = comprobarAnchura(salida, texto)

        for i, linea in ipairs(lineas) do

            comprobarAltura(salida)

            salida.write(linea)

            if i ~= #lineas then
                local _, y = salida.getCursorPos()
                salida.setCursorPos(1, y + 1)
            end

        end

    end

end


--- Limpia las pantallas especificadas en la tabla 'salidas'.
--- @param salidas table Tabla que contiene las salidas a texto que se van a limpiar.
--- ------------------------------
function limpiarPantallas(salidas)
    for _, salida in ipairs(salidas) do
        salida.clear()
        salida.setCursorPos(1, 1)
    end
end


--- DA ERRORES
--- ################################################################################################
function textoNormal(salidas)

    for i = 2, #salidas do
        salidas[i].setTextScale(getConfig("TAM_TEXTO"))
    end

end

--- DA ERRORES
--- ################################################################################################
function textoGrande(salidas)

    for i = 2, #salidas do
        salidas[i].setTextScale(getConfig("TAM_TEXTO_GRANDE"))
    end

end


--- Establece el color del texto en múltiples salidas.
--- @param salidas table La lista de salidas a colorear.
--- @param color number El código de color para establecer en las salidas.
--- -----------------------------
function colorear(salidas, color)

    for _, salida in ipairs(salidas) do
        salida.setTextColor(color)
    end

end


function preguntarYN(salidas, pregunta)

    colorear(salidas, colors.yellow)
    escribirTexto(salidas, pregunta .. " (s/n): ")

    colorear(salidas, getConfig("COLORD_TEXTO"))
    if io.read() == "s" then
        escribirTextoLN(salidas, "")
        return true
    else
        escribirTextoLN(salidas, "")
        return false
    end

end


function centrarTextoX(salidas, texto)

    for _, salida in ipairs(salidas) do
        local xSize, _ = salida.getSize()
        local _, yCursor = salida.getCursorPos()
        salida.setCursorPos(math.floor((xSize/2)-(#texto/2) + 0.5), yCursor)
    end

end


function centrarY(salidas)

    for _, salida in ipairs(salidas) do
        local xCursor, ySize = salida.getSize()
        salida.setCursorPos(xCursor, math.floor(ySize/2))
    end

end


--- Dada una ventana, a la primera y última linea las rellena con "-".
--- y a las demás con "|" solo en la primera y última columna.
--- En las esquiaunas pone "+".
--- + \+ ---- +
--- + \|......|
--- + \|......|
--- + \+ ---- +
--- @param salida Redirect La salida de texto en la que se va a encuadrar la ventana.
--- ------------------------------
function encuadrarVentana1(salida, izq, der)

    izq = izq or false
    der = der or false

    if not izq and not der then

        local xCursor, yCursor = salida.getCursorPos()
        local xSize, ySize = salida.getSize()

        salida.setCursorPos(1, 1)
        salida.write("+ ")
        salida.write(string.rep("-", xSize-4))
        salida.write(" +")

        salida.setCursorPos(1, ySize)
        salida.write("+ ")
        salida.write(string.rep("-", xSize-4))
        salida.write(" +")

        for i = 2, ySize-1 do
            salida.setCursorPos(1, i)
            salida.write("|")
            salida.setCursorPos(xSize, i)
            salida.write("|")
        end

        salida.setCursorPos(xCursor, yCursor)

    elseif izq and not der then

        local xCursor, yCursor = salida.getCursorPos()
        local xSize, ySize = salida.getSize()

        salida.setCursorPos(1, 1)
        salida.write("--")
        salida.write(string.rep("-", xSize-4))
        salida.write("-+")

        salida.setCursorPos(1, ySize)
        salida.write("--")
        salida.write(string.rep("-", xSize-4))
        salida.write("-+")

        for i = 2, ySize-1 do
            salida.setCursorPos(xSize, i)
            salida.write("|")
        end

        salida.setCursorPos(xCursor, yCursor)


    elseif not izq and der then

        local xCursor, yCursor = salida.getCursorPos()
        local xSize, ySize = salida.getSize()

        salida.setCursorPos(1, 1)
        salida.write("+-")
        salida.write(string.rep("-", xSize-4))
        salida.write("--")

        salida.setCursorPos(1, ySize)
        salida.write("+-")
        salida.write(string.rep("-", xSize-4))
        salida.write("--")

        for i = 2, ySize-1 do
            salida.setCursorPos(1, i)
            salida.write("|")
        end

        salida.setCursorPos(xCursor, yCursor)

    else

        local xCursor, yCursor = salida.getCursorPos()
        local xSize, ySize = salida.getSize()

        salida.setCursorPos(1, 1)
        salida.write("+-")
        salida.write(string.rep("-", xSize-4))
        salida.write("-+")

        salida.setCursorPos(1, ySize)
        salida.write("+-")
        salida.write(string.rep("-", xSize-4))
        salida.write("-+")

        salida.setCursorPos(xCursor, yCursor)

    end


end


--- Esta función es un simple sleep que determina una velocidad mínima para el SO
--- de manera que el usuario pueda leer los mensajes (que no suelen ser importantes).
function dormirDefecto()

    sleep(0.2)
    
end
