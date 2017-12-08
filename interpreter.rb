=begin

interpreter.rb

Descripcion: Interpretador del lenguaje de programacion Bitiondo 

Autores:
    Lautaro Villalon. 12-10427
    Yarima Luciani. 13-10770

=end

require_relative 'symbolTable.rb'
require_relative 'runtimeErrors.rb'

class Interpretador

    def initialize(nodoInicial)
        @nodoInicial = nodoInicial
        @tablasSimbolos = []
        @contadorTablas = -1 
    end


    def interpretar()
        if @nodoInicial.bloquePrincipal != nil then
            interpretadorBloquePrincipal(@nodoInicial.bloquePrincipal)
        end
    end


    def interpretadorBloquePrincipal(nodoBloquePrincipal)
        if nodoBloquePrincipal.declaraciones != nil then
            @contadorTablas = @contadorTablas + 1

            tabla = TablaSimbolos.new @contadorTablas
            @tablasSimbolos.push(tabla)

            interpretadorDeclaraciones(nodoBloquePrincipal.declaraciones, @contadorTablas)
        end

        if nodoBloquePrincipal.instrucciones != nil then
            interpretadorInstrucciones(nodoBloquePrincipal.instrucciones, @contadorTablas)
        end

        if nodoBloquePrincipal.declaraciones != nil then 
            @tablasSimbolos.pop()
            @contadorTablas = @contadorTablas - 1
        end
    end


    def interpretadorDeclaraciones(nodoDeclaraciones, idTabla)

        interpretadorDeclaracion(nodoDeclaraciones.declaracion, idTabla)

        if nodoDeclaraciones.declaraciones != nil then
            interpretadorDeclaraciones(nodoDeclaraciones.declaraciones, idTabla)
        end
    end


    def interpretadorDeclaracion(nodoDeclaracion, idTabla)

        if nodoDeclaracion.tamanio != nil then
            tamanioExistente = interpretadorExpresion(nodoDeclaracion.tamanio, idTabla)
            if tamanioExistente < 0 then
                # ERROR DE INICIALIZACION: TAMANIO NEGATIVO DE BITS.
                error = ErrorEjecucion.new(nodoDeclaracion.tamanio, "Error de longitud de bits: inicializacion negativa", nil)
                error.to_s
            end
            @tablasSimbolos[idTabla].insertar(nodoDeclaracion.id, nodoDeclaracion.tipo, tamanioExistente, nil)

        else
            @tablasSimbolos[idTabla].insertar(nodoDeclaracion.id, nodoDeclaracion.tipo, nil, nil)
        end

        if nodoDeclaracion.asignacion != nil then
            valorAsignado = interpretadorExpresion(nodoDeclaracion.asignacion.valor, idTabla)
            
            if nodoDeclaracion.tamanio != nil then
                tamanioAsignado = valorAsignado.length - 2

                if tamanioExistente != tamanioAsignado then
                    # ERROR DE TAMANIO DE ASIGNACION DE BITS
                    error = ErrorEjecucion.new(nodoDeclaracion.asignacion.valor, "Error de longitud de bits: inicializacion", tamanioExistente)
                    error.to_s
                end
            end

            @tablasSimbolos[idTabla].actualizarAsignacion(nodoDeclaracion.id, valorAsignado)
        end

    end


    def interpretadorInstrucciones(nodoInstrucciones, idTabla)

        interpretadorInstruccion(nodoInstrucciones.instruccion, idTabla)

        if nodoInstrucciones.instrucciones != nil then
            interpretadorInstrucciones(nodoInstrucciones.instrucciones, idTabla)
        end
    end


    def interpretadorInstruccion(nodoInstruccion, idTabla)

        if nodoInstruccion.instruccion.is_a?(NodoAsignacion) then
            interpretadorAsignacion(nodoInstruccion.instruccion, idTabla)

        elsif nodoInstruccion.instruccion.is_a?(NodoEntrada) then
            interpretadorEntrada(nodoInstruccion.instruccion, idTabla)

        elsif nodoInstruccion.instruccion.is_a?(NodoSalida) then
            interpretadorSalida(nodoInstruccion.instruccion, idTabla)

        elsif nodoInstruccion.instruccion.is_a?(NodoCondicional) then
            interpretadorCondicional(nodoInstruccion.instruccion, idTabla)

        elsif nodoInstruccion.instruccion.is_a?(NodoFor) then
            interpretadorFor(nodoInstruccion.instruccion, idTabla) 

        elsif nodoInstruccion.instruccion.is_a?(NodoForBits) then
            interpretadorForBits(nodoInstruccion.instruccion, idTabla)

        elsif nodoInstruccion.instruccion.is_a?(NodoWhile) then
            interpretadorWhile(nodoInstruccion.instruccion, idTabla)

        elsif nodoInstruccion.instruccion.is_a?(NodoInicial) then
            if nodoInstruccion.instruccion.bloquePrincipal != nil then
                interpretadorBloquePrincipal(nodoInstruccion.instruccion.bloquePrincipal)
            end
        end
    end


    def interpretadorAsignacion(nodoAsignacion, idTabla)

        asignacion = interpretadorExpresion(nodoAsignacion.expresion, idTabla)

        tamanioExistente = tamanioExpresion(nodoAsignacion.id, idTabla)

        if tamanioExistente != "Error de Tamanio" then
            
            tamanioAsignado = tamanioExpresion(nodoAsignacion.expresion, idTabla)
            
            if tamanioAsignado != "Error de Tamanio" && tamanioExistente != tamanioAsignado then
                # ERROR DE ASIGNACION TAMANIO BITS
                error = ErrorEjecucion.new(nodoAsignacion.expresion, "Error de longitud de bits: asignacion", tamanioExistente)
                error.to_s
            end
        end

        if nodoAsignacion.posicion != nil then
            valorPosicion = interpretadorExpresion(nodoAsignacion.posicion, idTabla)
            valorExistente = encontrarValorTablas(nodoAsignacion.id.valor.str, idTabla)

            if valorPosicion > tamanioExistente then
                # ERROR DE ASIGNACION ACCESO A POSICION INEXISTENTE
                error = ErrorEjecucion.new(nodoAsignacion.posicion, "Error de asignacion acceso a posicion inexistente", nil)
                error.to_s
            end

            if Integer(asignacion) != 1 && Integer(asignacion) != 0 then
                # ERROR DE ASIGNACION A POSICION DE BITARRAY
                error = ErrorEjecucion.new(nodoAsignacion.posicion, "Error de asignacion a posicion de bitarray", nil)
                error.to_s
            end

            valorExistente[-(valorPosicion+1)] = asignacion.to_s

            @tablasSimbolos[idTabla].actualizarAsignacion(nodoAsignacion.id, valorExistente)

        else
            @tablasSimbolos[idTabla].actualizarAsignacion(nodoAsignacion.id, asignacion)
        end

    end

    def interpretadorExpresion(nodoExpresion, idTabla)
        if nodoExpresion.is_a?(NodoExpresionBin) then
            return interpretadorExpresionBin(nodoExpresion, idTabla)

        elsif nodoExpresion.is_a?(NodoExpresionUn) then
            return interpretadorExpresionUn(nodoExpresion, idTabla)

        elsif nodoExpresion.is_a?(NodoId) then
            return interpretadorId(nodoExpresion, idTabla)

        elsif nodoExpresion.is_a?(NodoInt) then
            return interpretadorInt(nodoExpresion, idTabla)

        elsif nodoExpresion.is_a?(NodoBool) then
            return interpretadorBool(nodoExpresion, idTabla)

        elsif nodoExpresion.is_a?(NodoBits) then
            return interpretadorBits(nodoExpresion, idTabla)

        elsif nodoExpresion.is_a?(NodoStr) then
            return interpretadorStr(nodoExpresion, idTabla)

        end
    end

    def interpretadorExpresionBin(nodoExpresionBin, idTabla)
        operandoIzq = interpretadorExpresion(nodoExpresionBin.expresion1, idTabla)
        operandoDer = interpretadorExpresion(nodoExpresionBin.expresion2, idTabla)

        if nodoExpresionBin.opBinario.operador == "ACCESS" then
            operador = nodoExpresionBin.opBinario.operador
        else
            operador = nodoExpresionBin.opBinario.operador.type.upcase
        end


        if nodoExpresionBin.tipo == 'Aritmetica' then

            if operador == "PLUS" then 
                return operandoIzq + operandoDer

            elsif operador == "MINUS" then 
                return operandoIzq - operandoDer

            elsif operador == "PRODUCT" then 
                return operandoIzq * operandoDer

            elsif operador == "DIVISION" then 
                if operandoDer == 0 then
                    # ERROR DE DIVISION POR CERO
                    error = ErrorEjecucion.new(nodoExpresionBin.expresion2, "Error de division por cero", nil)
                    error.to_s
                end

                return operandoIzq / operandoDer    

            elsif operador == "MODULE" then 
                if operandoDer == 0 then
                    # ERROR DE DIVISION POR CERO
                    error = ErrorEjecucion.new(nodoExpresionBin.expresion2, "Error de division por cero", nil)
                    error.to_s
                end

                return operandoIzq % operandoDer

            elsif operador == "LESSTHAN" then 
                return operandoIzq < operandoDer

            elsif operador == "MORETHAN" then 
                return operandoIzq > operandoDer

            elsif operador == "LESSOREQUALTHAN" then 
                return operandoIzq <= operandoDer

            elsif operador == "MOREOREQUALTHAN" then 
                return operandoIzq >= operandoDer
            
            end
        
        end 

        if nodoExpresionBin.tipo == "Comparacion" then 

            if operador == "EQUALS" then 
                return operandoIzq == operandoDer

            elsif operador == "NOTEQUAL" then 
                return operandoIzq != operandoDer
            
            end
        
        end

        if nodoExpresionBin.tipo == "Logica" then

            if operador == "AND" then 
                return operandoIzq && operandoDer

            elsif operador == "OR" then 
                return operandoIzq || operandoDerecho
            
            end
        
        end

        if nodoExpresionBin.tipo == "Bits" then 
            tamanio1 = operandoIzq.length - 2
            tamanio2 = operandoDer.length - 2

            if tamanio1 != tamanio2 then
                # ERROR DE EXPRESION BINARIA DE BITS DE TAMANIOS DIFERENTES
                error = ErrorEjecucion.new(nodoExpresionBin, "Error de longitud de bits: expresion", nil)
                error.to_s
            end

            if operador == "ANDBITS" then
                resultado = (operandoIzq.to_i(2) & operandoDer.to_i(2)).to_s(2)

                resultado = "0b" + "0"*(tamanio1-resultado.length) + resultado

                return resultado
            

            elsif operador == "ORBITS" then 
                resultado = (operandoIzq.to_i(2) | operandoDer.to_i(2)).to_s(2)

                resultado = "0b" + "0"*(tamanio1-resultado.length) + resultado

                return resultado
            end 
        end

        if nodoExpresionBin.tipo == "BitsInt" then 

            tamanio = operandoIzq.length - 2

            if operandoDer >= tamanio then
                # ERROR DE TAMANIO EXPRESION BINARIA BITSINT.
                error = ErrorEjecucion.new(nodoExpresionBin, "Error de longitud de bits: expresion BitsInt", nil)
                error.to_s

            end

            if operador == "RIGHTDISPLACEMENT" then 
                resultado = (operandoIzq.to_i(2) >> operandoDer).to_s(2)
                resultado = "0b" + "0"*(tamanio - resultado.length) + resultado
                return resultado

            elsif operador == "LEFTDISPLACEMENT" then 
                resultado = (operandoIzq.to_i(2) << operandoDer).to_s(2)
                if resultado != "0" then
                    resultado = "0b" + resultado[(resultado.length-tamanio)..-1]
                else
                    resultado = "0b" + "0"*tamanio
                end

                return resultado

            elsif operador == "ACCESS" then
                resultado = operandoIzq.reverse
                resultado = resultado[operandoDer]

                return resultado

            end 

        end
    end

    def interpretadorExpresionUn(nodoExpresionUn, idTabla)
        operando = interpretadorExpresion(nodoExpresionUn.expresion, idTabla)
        operador = nodoExpresionUn.opUnario.operador.type.upcase

        if nodoExpresionUn.tipo == "Aritmetica" then 

            if operador == "MINUS" then 
                return -operando

            elsif operador == "AT" then 
                if operando < 0 then
                    # ERROR DE ENTEROS NEGATIVOS
                    error = ErrorEjecucion.new(nodoExpresionUn, "Error de enteros negativos", nil)
                    error.to_s
                end

                if operando > 4294967295 then
                    # ERROR DE NUMERO QUE OCUPA MAS DE 32 BITS
                    error = ErrorEjecucion.new(nodoExpresionUn, "Error de numero que ocupa mas de 32 bits", nil)
                    error.to_s
                end

                valor = operando.to_s(2)

                valor = "0b" + "0"*(32-valor.length) + valor

                return valor
            end 

        end 

        if nodoExpresionUn.tipo == "Logica" then

            if operador == "NOT" then 
                return !operando 
            end

        end 

        if nodoExpresionUn.tipo == "Bits" then 

            if operador == "NOTBITS" then 
                negacion = "0b"+operando[2..-1].tr("10", "01")

                return negacion


            elsif operador == "DOLLAR" then 
                if operando.length != 34 then

                    # ERROR TAMANIO DIFERENTE A 32 BITS
                    error = ErrorEjecucion.new(nodoExpresionUn, "Error de longitud de bits: expresion dollar", nil)
                    error.to_s

                end

                return operando.to_i(2)
            end

        end 
    end

    def interpretadorEntrada(nodoEntrada, idTabla)

        tipo = encontrarTipoTablas(nodoEntrada.id.valor.str, idTabla).str

        entrada = $stdin.gets

        entrada = entrada.chomp

        # CHEQUEO DE TIPOS
        if tipo.upcase == "BOOL" then

            if booleano(entrada) == "Imposible convertir a booleano" then
                # ERROR DE TIPO DE INPUT
                puts "El valor de entrada esperado debe ser de tipo 'bool'."
                interpretadorEntrada(nodoEntrada, idTabla)
                return
            end

            entrada = booleano(entrada)

        elsif tipo.upcase == "INT" then
            if !entero(entrada) then
                # ERROR DE TIPO DE INPUT
                puts "El valor de entrada esperado debe ser de tipo 'int'."
                interpretadorEntrada(nodoEntrada, idTabla)
                return
            end

            entrada = entrada.to_i

        elsif tipo.upcase == "BITS" then
            if !(entrada =~ /\A0b[01]+/) then
                # ERROR DE TIPO DE INPUT
                puts "El valor de entrada esperado debe ser de tipo 'bits'."
                interpretadorEntrada(nodoEntrada, idTabla)
                return
            end

            tamanioExistente = encontrarTamanioTablas(nodoEntrada.id, idTabla)
            tamanioAsignado = entrada.length-2

            if tamanioExistente != tamanioAsignado then
                # ERROR DE TAMANIO EN LA ENTRADA
                puts "El valor de entrada esperado debe tener tamanio #{tamanioExistente}."
                interpretadorEntrada(nodoEntrada, idTabla)
                return
            end
        end


        @tablasSimbolos[idTabla].actualizarAsignacion(nodoEntrada.id, entrada)
    end 
    
    def interpretadorSalida(nodoSalida, idTabla)
        expresiones = []

        interpretadorExpMultiple(nodoSalida.expMult, idTabla, expresiones)

        expresiones.each do |exp|
            if exp.is_a?(String) then
                exp = exp[1..-2]

                exp = exp.gsub("\\n", "\n")

                exp = exp.gsub("\\\"", "\"")
            end
            print exp
        end

        if nodoSalida.token.type.upcase == "OUTPUTLN" then
            puts
        end
    end


    def interpretadorExpMultiple(nodoExpMultiple, idTabla, expresiones)
        expresiones.push(interpretadorExpresion(nodoExpMultiple.expresion, idTabla))

        if nodoExpMultiple.expMultiple != nil then
            interpretadorExpMultiple(nodoExpMultiple.expMultiple, idTabla, expresiones)
        end
    end


    def interpretadorCondicional(nodoCondicional, idTabla)
        condicion = interpretadorExpresion(nodoCondicional.expresion, idTabla)

        if (condicion) then
            interpretadorInstDec(nodoCondicional.instDec, idTabla)

        elsif nodoCondicional.clausuraElse != nil then
            interpretadorInstDec(nodoCondicional.clausuraElse.instDec, idTabla)
        end
    end


    def interpretadorInstDec(nodoInstDec, idTabla)
        if nodoInstDec.is_a?(NodoInstruccion) then
            interpretadorInstruccion(nodoInstDec, idTabla)

        elsif nodoInstDec.is_a?(NodoDeclaracion) then
            interpretadorDeclaracion(nodoInstDec, idTabla)
        end
    end


    def interpretadorFor(nodoFor, idTabla)

        valorInicial = interpretadorExpresion(nodoFor.asignacion.expresion, idTabla)
        valorDePaso = interpretadorExpresion(nodoFor.expresion2, idTabla)

        # CREACION DE TABLA DE SIMBOLOS DEL FOR
        @contadorTablas = @contadorTablas + 1

        tabla = TablaSimbolos.new @contadorTablas
        tipoVarIteracion = Token.new("int", -1, -1)

        tabla.insertar(nodoFor.asignacion.id, tipoVarIteracion, nil, valorInicial, false)
        @tablasSimbolos.push(tabla)

        idTabla = idTabla+1


        # INTERPRETACION DEL FOR


        while (interpretadorExpresion(nodoFor.expresion1, idTabla))
            interpretadorInstDec(nodoFor.instDec, idTabla)
            valorInicial = valorInicial + valorDePaso

            @tablasSimbolos[idTabla].actualizarAsignacion(nodoFor.asignacion.id, valorInicial)

        end

        @tablasSimbolos.pop()
        @contadorTablas = @contadorTablas - 1
    end


    # FAAAAALTA
    def interpretadorForBits(nodoForBits, idTabla)
        expresionBits = interpretadorExpresion(nodoForBits.expresion1, idTabla)

        expresionInt = interpretadorExpresion(nodoForBits.expresion2, idTabla)

        tamanioBits = expresionBits.length - 2

        if expresionInt >= tamanioBits then
            # ERROR DE ASIGNACION A POSICION INEXISTENTE   
            error = ErrorEjecucion.new(nodoForBits.expresion2, "Error de asignacion acceso a posicion inexistente", nil)
            error.to_s
        end

        # AGREGAMOS LA TABLA DE SIMBOLOS
        tipoVarIteracion = Token.new("int", -1, -1)
        @contadorTablas = @contadorTablas + 1

        tabla = TablaSimbolos.new @contadorTablas

        tabla.insertar(nodoForBits.id, tipoVarIteracion, nil, nil, false)
        @tablasSimbolos.push(tabla)

        idTabla = idTabla+1



        # ASIGNAMOS LA VARIABLE DE ITERACION
        expresionBits = expresionBits.reverse[0..-3]

        valorInicial = Integer(expresionBits[expresionInt])

        @tablasSimbolos[idTabla].actualizarAsignacion(nodoForBits.id, valorInicial)

        if nodoForBits.token.str.upcase == "HIGHER" then

            i = expresionInt

            while (i < tamanioBits) 
                interpretadorInstDec(nodoForBits.instDec, idTabla)

                i = i + 1

                if i == tamanioBits then
                    break
                end

                valorNuevo = Integer(expresionBits[i])
                @tablasSimbolos[idTabla].actualizarAsignacion(nodoForBits.id, valorNuevo)
            end

        elsif nodoForBits.token.str.upcase == "LOWER" then

            i = expresionInt

            while (i >= 0) 

                interpretadorInstDec(nodoForBits.instDec, idTabla)

                i = i - 1

                valorNuevo = Integer(expresionBits[i])
                @tablasSimbolos[idTabla].actualizarAsignacion(nodoForBits.id, valorNuevo)
            end

        end

        @tablasSimbolos.pop()
        @contadorTablas = @contadorTablas - 1       

    end


    def interpretadorWhile(nodoWhile, idTabla)

        if nodoWhile.repeat != nil then
            interpretadorInstDec(nodoWhile.instDec1, idTabla)

            while (interpretadorExpresion(nodoWhile.expresion, idTabla))

                if nodoWhile.dow != nil then
                    interpretadorInstDec(nodoWhile.instDec2, idTabla)
                end
                interpretadorInstDec(nodoWhile.instDec1, idTabla)
                    
            end
        else
            while (interpretadorExpresion(nodoWhile.expresion, idTabla))

                if nodoWhile.dow != nil then
                    interpretadorInstDec(nodoWhile.instDec2, idTabla)
                end
            end
        end         
    end

    def interpretadorId(nodoId, idTabla)
        nombre = nodoId.valor.str

        valor = encontrarValorTablas(nombre, idTabla)

        return valor
    end


    def interpretadorInt(nodoInt, idTabla)
        numero = Integer(nodoInt.valor.str)
        return numero
    end


    def interpretadorBool(nodoBool, idTabla)
        return booleano(nodoBool.valor.str)
    end


    def interpretadorBits(nodoBits, idTabla)
        return nodoBits.valor.str
    end


    def interpretadorStr(nodoString, idTabla)
        return nodoString.valor.str
    end

    # FUNCIONES DE VERIFICACION DE TAMANIO

    def tamanioExpresion(nodoExpresion, idTabla)
        if nodoExpresion.is_a?(NodoExpresionBin) then
            return tamanioExpresionBin(nodoExpresion, idTabla)

        elsif nodoExpresion.is_a?(NodoExpresionUn) then
            return tamanioExpresionUn(nodoExpresion, idTabla)

        elsif nodoExpresion.is_a?(NodoId) then

            return encontrarTamanioTablas(nodoExpresion.valor.str, idTabla)

        elsif nodoExpresion.is_a?(NodoBits) then
            return nodoExpresion.tamanio
        else
            return "Error de Tamanio"
        end
    end

    def tamanioExpresionBin(nodoExpresion, idTabla)

        if nodoExpresion.tipo != "Bits" && nodoExpresion.tipo != "BitsInt" then
            return "Error de Tamanio"
        end

        tamanio1 = tamanioExpresion(nodoExpresion.expresion1, idTabla)
        tamanio2 = tamanioExpresion(nodoExpresion.expresion2, idTabla)

        if nodoExpresion.tipo == "BitsInt" then
            return tamanio1
        end

        if tamanio1 != "Error de Tamanio" && tamanio1 != tamanio2 then

            error = ErrorEjecucion.new(nodoExpresion, "Error de longitud de bits: expresion", nil)
            @errores.push(error)
            return "Tamanios diferentes"
        else
            return tamanio1
        end
    end

    def tamanioExpresionUn(nodoExpresion, idTabla)
        if nodoExpresion.tipo == "Aritmetica" && nodoExpresion.tipoResultado == "BITS" then
            return 32
        end

        if nodoExpresion.tipo != "Bits" then
            return "Error de Tamanio"
        end

        tamanio = tamanioExpresion(nodoExpresion.expresion, idTabla)

        if nodoExpresion.tipo == "Bits" && nodoExpresion.tipoResultado == "INT" then
            if tamanio != 32 then
                error = ErrorEjecucion.new(nodoExpresion, "Error de longitud de bits: expresion dollar", nil)
                @errores.push(error)
                return "Error de Tamanio"
            end
        end

        return tamanio
    end

    def encontrarTamanioTablas(identificador, idTabla)
        
        for i in (0..idTabla).reverse_each
            if @tablasSimbolos[i].contiene(identificador) then

                tamanio = @tablasSimbolos[i].encontrar(identificador)[1]
                if tamanio != nil then
                    return Integer(tamanio)
                else
                    return "Error de Tamanio"
                end
            end
        end

        return "Error de Tamanio"
    end

    def encontrarValorTablas(identificador, idTabla)
        
        for i in (0..idTabla).reverse_each
            if @tablasSimbolos[i].contiene(identificador) then

                encontrar = @tablasSimbolos[i].encontrar(identificador)
                tipo = encontrar[0].str.upcase
                valor = encontrar[2]

                if valor != nil then

                    if tipo == "INT" then
                        return Integer(valor)

                    elsif tipo == "BOOL" then
                        return booleano(valor)

                    else
                        return valor
                    end
                else
                    return "Error de Valor"
                end
            end
        end

        return "Error de Valor"
    end 

    def booleano(str)

        if str=="true" || str == true then
            return true

        elsif str == "false" || str == false then
            return false

        end

        return "Imposible convertir a booleano"
    end

    def entero(str)
        if str =~ /\A[-+]?\d+\z/ then
            return true
        else
            return false
        end
    end

    # encontrarTipoTablas
    # Funcion que devuelve el tipo de un nodo identificador
    # Parametros de entrada: identificador, idTabla
    def encontrarTipoTablas(identificador, idTabla)
        
        for i in (0..idTabla).reverse_each

            if @tablasSimbolos[i].contiene(identificador) then

                tipo = @tablasSimbolos[i].encontrar(identificador)[0]
                return tipo
            end
        end

        return nil
    end
end

