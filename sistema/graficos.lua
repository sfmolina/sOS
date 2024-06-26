------------------------------
--  AUTOR:       @sfmolina  --
--  Versión:     v1         --
--  Modificado:  26jun24    --
------------------------------



--- IMPORTS --------------------------------------------------------------------


local control = dofile("sOS/sistema/control.lua")


-- ATRIBUTOS -------------------------------------------------------------------


local graficos = {}


--- FUNCIONES ------------------------------------------------------------------


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
local function comprobarAnchura(salida, texto)

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
function graficos.escribirTextoLN(salidas, texto)

    local routines = {}

    for _, salida in ipairs(salidas) do

        table.insert(
            routines,
            function()

                local lineas = comprobarAnchura(salida, texto)

                for _, linea in ipairs(lineas) do

                    comprobarAltura(salida)

                    salida.write(linea)

                    local _, y = salida.getCursorPos()
                    salida.setCursorPos(1, y + 1)

                end
                
            end
        )

    end

    parallel.waitForAll(table.unpack(routines))

end


function graficos.escribirTexto(salidas, texto)

    local routines = {}

    for _, salida in ipairs(salidas) do

        table.insert(
            routines,
            function()

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
        )

    end

    parallel.waitForAll(table.unpack(routines))

end


--- Limpia las pantallas especificadas en la tabla 'salidas'.
--- @param salidas table Tabla que contiene las salidas a texto que se van a limpiar.
--- ------------------------------
function graficos.limpiarPantallas(salidas)

    local routines = {}

    for _, salida in ipairs(salidas) do

        table.insert(
            routines,
            function()
                salida.clear()
                salida.setCursorPos(1, 1)
            end
        )

    end

    parallel.waitForAll(table.unpack(routines))

end


--- DA ERRORES
--- ################################################################################################
function graficos.textoNormal(salidas)

    for i = 2, #salidas do
        salidas[i].setTextScale(getConfig("TAM_TEXTO"))
    end

end

--- DA ERRORES
--- ################################################################################################
function graficos.textoGrande(salidas)

    for i = 2, #salidas do
        salidas[i].setTextScale(getConfig("TAM_TEXTO_GRANDE"))
    end

end


--- Establece el color del texto en múltiples salidas.
--- @param salidas table La lista de salidas a colorear.
--- @param color number El código de color para establecer en las salidas.
--- -----------------------------
function graficos.colorear(salidas, color)

    local routines = {}

    for _, salida in ipairs(salidas) do

        table.insert(
            routines,
            function()
                salida.setTextColor(color)
            end
        )

    end

    parallel.waitForAll(table.unpack(routines))

end


function graficos.preguntarYN(salidas, pregunta)

    graficos.colorear(salidas, colors.yellow)
    graficos.escribirTexto(salidas, pregunta .. " (s/n): ")

    graficos.colorear(salidas, control.getConfig("COLORD_TEXTO"))
    if io.read() == "s" then
        graficos.escribirTextoLN(salidas, "")
        return true
    else
        graficos.escribirTextoLN(salidas, "")
        return false
    end

end


function graficos.centrarTextoX(salidas, texto)

    local routines = {}

    for _, salida in ipairs(salidas) do

        table.insert(
            routines,
            function()
                local xSize, _ = salida.getSize()
                local _, yCursor = salida.getCursorPos()
                salida.setCursorPos(math.floor((xSize/2)-(#texto/2) + 0.5), yCursor)
            end
        )

    end

    parallel.waitForAll(table.unpack(routines))

end


function graficos.centrarY(salidas)

    local routines = {}

    for _, salida in ipairs(salidas) do

        table.insert(
            routines,
            function()
                local xCursor, ySize = salida.getSize()
                salida.setCursorPos(xCursor, math.floor(ySize/2))
            end
        )

    end

    parallel.waitForAll(table.unpack(routines))

end


--- Dada una ventana, a la primera y última linea las rellena con "-".
--- y a las demás con "|" solo en la primera y última columna.
--- En las esquinas pone "+".
--- + \+ ---- +
--- + \|......|
--- + \|......|
--- + \+ ---- +
--- @param salida Redirect La salida de texto en la que se va a encuadrar la ventana.
--- ------------------------------
function graficos.encuadrarVentana1(salida, izq, der)

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


return graficos
