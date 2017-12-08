=begin

astParser.rb

Descripcion: AST del parser del lenguaje de programacion Bitiondo 

Autores:
	Lautaro Villalon. 12-10427
	Yarima Luciani. 13-10770

=end

$cantidadTablas = -1
$tablasDeSimbolos = []

class NodoGeneral;
	def printNivel(num)
		for i in 1..num
			print "    "
		end
	end
end


class NodoInicial < NodoGeneral

	attr_accessor :bloquePrincipal

	def initialize(bloquePrincipal)
		@bloquePrincipal = bloquePrincipal
	end

	def printNodo(nivel, simbolo)
		printNivel(nivel)
		puts "BEGIN"

		if @bloquePrincipal != nil then
			@bloquePrincipal.printNodo(nivel+1, simbolo)
		end
		printNivel(nivel)
		puts "END"
	end
end


class NodoBloquePrincipal < NodoGeneral

	attr_accessor :declaraciones, :instrucciones

	def initialize(declaraciones, instrucciones)
		@declaraciones = declaraciones
		@instrucciones = instrucciones
	end

	def printNodo(nivel, simbolo)
		if @declaraciones != nil then
			if simbolo then
				$cantidadTablas = $cantidadTablas + 1

				tabla = TablaSimbolos.new $cantidadTablas
				$tablasDeSimbolos.push(tabla)

				@declaraciones.insertarEnTabla()

				$tablasDeSimbolos[$cantidadTablas].printTabla(nivel)

			else
				@declaraciones.printNodo(nivel, simbolo)
			end

		end
		if @instrucciones != nil then
			@instrucciones.printNodo(nivel, simbolo)
		end
	end
end


class NodoBloques < NodoGeneral

	attr_accessor :bloquePrincipal

	def initialize(bloquePrincipal)
		@bloquePrincipal = bloquePrincipal
	end

	def printNodo(nivel, simbolo)
		printNivel(nivel)
		puts "BEGIN"

		if @bloquePrincipal != nil then
			@bloquePrincipal.printNodo(nivel+1, simbolo)
		end

		printNivel(nivel)
		puts "END"
	end
end


class NodoDeclaraciones < NodoGeneral

	attr_accessor :declaracion, :declaraciones

	def initialize(declaracion, declaraciones)
		@declaracion = declaracion
		@declaraciones = declaraciones
	end

	def insertarEnTabla()
		@declaracion.insertarEnTabla()

		if @declaraciones != nil then
			@declaraciones.insertarEnTabla()
		end
	end

	def printNodo(nivel, simbolo)

		@declaracion.printNodo(nivel, simbolo)

		if @declaraciones != nil then
			@declaraciones.printNodo(nivel, simbolo)
		end

	end
end


class NodoDeclaracion < NodoGeneral

	attr_accessor :tipo, :id, :tamanio, :asignacion

	def initialize(tipo, id, tamanio, asignacion)
		@tipo = tipo
		@id = id
		@tamanio = tamanio
		@asignacion = asignacion
	end

	def insertarEnTabla()
		$tablasDeSimbolos[$cantidadTablas].insertar(@id, @tipo, @tamanio, @asignacion)
	end

	def printNodo(nivel, simbolo)

		printNivel(nivel)
		puts "DECLARE"
		nivel = nivel + 1

		printNivel(nivel)
		puts "type: #{@tipo.str}"

		@id.printNodo(nivel, simbolo)

		if @tamanio != nil then
			printNivel(nivel)
			puts "size:"
			@tamanio.printNodo(nivel+1, simbolo)
		end

		if @asignacion != nil then
			printNivel(nivel)
			puts "value:"
			@asignacion.printNodo(nivel+1, simbolo)
		end
	end

end


class NodoInit < NodoGeneral

	attr_accessor :valor

	def initialize(valor)
		@valor = valor
	end

	def printNodo(nivel, simbolo)
		@valor.printNodo(nivel, simbolo)
	end
end


class NodoInstrucciones < NodoGeneral

	attr_accessor :instruccion, :instrucciones

	def initialize(instruccion, instrucciones)
		@instruccion = instruccion
		@instrucciones = instrucciones
	end

	def printNodo(nivel, simbolo)

		if @instruccion != nil then
			@instruccion.printNodo(nivel, simbolo)
		end

		if @instrucciones != nil then
			@instrucciones.printNodo(nivel, simbolo)
		end

	end
end


class NodoInstruccion < NodoGeneral

	attr_accessor :instruccion

	def initialize(instruccion)
		@instruccion = instruccion
	end

	def printNodo(nivel, simbolo)
		@instruccion.printNodo(nivel, simbolo)
	end

end


class NodoExpresionBin < NodoGeneral

	attr_accessor :expresion1, :opBinario, :expresion2, :tipo, :tipoResultado, :line, :column

	def initialize(expresion1, opBinario, expresion2, tipo, tipoResultado)
		@expresion1 = expresion1
		@opBinario = opBinario
		@expresion2 = expresion2
		@tipo = tipo
		@tipoResultado = tipoResultado
		@line = expresion1.line
		@column = expresion1.column
	end

	def printNodo(nivel, simbolo)
		printNivel(nivel)
		puts "BIN_EXPRESSION:"
		@opBinario.printNodo(nivel+1, simbolo)

		printNivel(nivel+1)
		puts "left operand:"
		@expresion1.printNodo(nivel+2, simbolo)

		printNivel(nivel+1)
		puts "right operand:"
		@expresion2.printNodo(nivel+2, simbolo)

	end
end


class NodoExpresionUn < NodoGeneral

	attr_accessor :opUnario, :expresion, :entero, :tipo, :tipoResultado, :line, :column

	def initialize(opUnario, expresion, entero, tipo, tipoResultado)
		@opUnario = opUnario
		@expresion = expresion
		@entero = entero
		@tipo = tipo
		@tipoResultado = tipoResultado
		@line = expresion.line
		@column = expresion.column
	end

	def printNodo(nivel, simbolo)
		printNivel(nivel)
		puts "UN_EXPRESSION:"
		@opUnario.printNodo(nivel+1, simbolo)

		printNivel(nivel+1)
		puts "operand:"
		@expresion.printNodo(nivel+2, simbolo)

		if entero != nil then
			printNivel(nivel+1)
			puts "index:"
			@entero.printNodo(nivel+2, simbolo)
		end

	end
end


class NodoOperador < NodoGeneral

	attr_accessor :operador

	def initialize(operador)
		@operador = operador
	end

	def printNodo(nivel, simbolo)
		printNivel(nivel)
		puts "operator:"
		printNivel(nivel+1)
		if operador == 'ACCESS' then
			puts "#{@operador}"
		else
			puts "#{@operador.type}"
		end
	end
end


class NodoAsignacion < NodoGeneral

	attr_accessor :id, :expresion, :posicion

	def initialize(id, expresion, posicion)
		@id = id
		@expresion = expresion
		@posicion = posicion
	end

	def insertarEnTabla()
		tipo = Token.new("int", -1, -1)

		$tablasDeSimbolos[$cantidadTablas].insertar(@id, tipo, nil, @expresion, false)
	end

	def printNodo(nivel, simbolo)
		printNivel(nivel)
		puts "ASSIGN"

		@id.printNodo(nivel+1, simbolo)

		if @posicion != nil then
			printNivel(nivel+1)
			puts "position:"
			@posicion.printNodo(nivel+2, simbolo)
		end

		printNivel(nivel+1)
		puts "value:"

		@expresion.printNodo(nivel+2, simbolo)
	end
end


class NodoEntrada < NodoGeneral

	attr_accessor :id

	def initialize(id)
		@id = id
	end

	def printNodo(nivel, simbolo)
		printNivel(nivel)
		puts "INPUT"

		@id.printNodo(nivel+1, simbolo)
	end
end


class NodoSalida < NodoGeneral

	attr_accessor :token, :expMult

	def initialize(token, expMult)
		@token = token
		@expMult = expMult
	end

	def printNodo(nivel, simbolo)
		printNivel(nivel)
		puts "#{token.type}"

		printNivel(nivel+1)
		puts "elements:"

		if @expMult != nil then
			@expMult.printNodo(nivel+2, simbolo)
		end
	end
end


class NodoExpMultiple < NodoGeneral

	attr_accessor :expresion, :expMultiple

	def initialize(expresion, expMultiple)
		@expresion = expresion
		@expMultiple = expMultiple
	end

	def printNodo(nivel, simbolo)

		if @expresion != nil then
			@expresion.printNodo(nivel, simbolo)
		end

		if @expMultiple != nil then
			@expMultiple.printNodo(nivel, simbolo)
		end

	end
end


class NodoCondicional < NodoGeneral

	attr_accessor :expresion, :instDec, :clausuraElse

	def initialize(expresion, instDec, clausuraElse)
		@expresion = expresion
		@instDec = instDec
		@clausuraElse = clausuraElse
	end

	def printNodo(nivel, simbolo)
		printNivel(nivel)
		puts "IF"

		printNivel(nivel+1)
		puts "condition:"

		@expresion.printNodo(nivel+2, simbolo)

		printNivel(nivel+1)
		puts "instruction:"

		if @instDec != nil then
			@instDec.printNodo(nivel+2, simbolo)
		end

		if @clausuraElse != nil then
			@clausuraElse.printNodo(nivel+1, simbolo)
		end
	end
end


class NodoClausuraElse < NodoGeneral

	attr_accessor :instDec

	def initialize(instDec)
		@instDec = instDec
	end

	def printNodo(nivel, simbolo)
		printNivel(nivel)
		puts "ELSE"

		printNivel(nivel+1)
		puts "instruction:"

		if @instDec != nil then
			@instDec.printNodo(nivel+2, simbolo)
		end
	end
end


class NodoFor < NodoGeneral

	attr_accessor :asignacion, :expresion1, :expresion2, :instDec

	def initialize(asignacion, expresion1, expresion2, instDec)
		@asignacion = asignacion
		@expresion1 = expresion1
		@expresion2 = expresion2
		@instDec = instDec
	end

	def printNodo(nivel, simbolo)

		if simbolo then
			# CREACION DE TABLA DE SIMBOLOS DEL FOR:
			$cantidadTablas = $cantidadTablas + 1

			tabla = TablaSimbolos.new $cantidadTablas
			$tablasDeSimbolos.push(tabla)

			@asignacion.insertarEnTabla()
		end

		printNivel(nivel)
		puts "FOR"

		@asignacion.printNodo(nivel+1, simbolo)

		@expresion1.printNodo(nivel+1, simbolo)

		@expresion2.printNodo(nivel+1, simbolo)

		printNivel(nivel+1)
		puts "instruction:"

		if simbolo then
			$tablasDeSimbolos[$cantidadTablas].printTabla(nivel+2)
		end

		if @instDec != nil then
			@instDec.printNodo(nivel+2, simbolo)
		end
	end
end


class NodoForBits < NodoGeneral

	attr_accessor :expresion1, :id, :expresion2, :token, :instDec

	def initialize(expresion1, id, expresion2, token, instDec)
		@expresion1 = expresion1
		@id = id
		@expresion2 = expresion2
		@token = token
		@instDec = instDec
	end

	def printNodo(nivel, simbolo)

		if simbolo then
			# CREACION DE TABLA DE SIMBOLOS DEL FOR:
			$cantidadTablas = $cantidadTablas + 1

			tabla = TablaSimbolos.new $cantidadTablas
			$tablasDeSimbolos.push(tabla)

			tipo = Token.new("int", -1, -1)

			$tablasDeSimbolos[$cantidadTablas].insertar(@id, tipo, nil, nil, false)
		end

		printNivel(nivel)
		puts "FOR BITS"

		printNivel(nivel+1)
		puts "value:"
		@expresion1.printNodo(nivel+2, simbolo)

		printNivel(nivel+1)
		puts "as:"
		@id.printNodo(nivel+2, simbolo)

		printNivel(nivel+1)
		puts "from:"
		@expresion2.printNodo(nivel+2, simbolo)

		printNivel(nivel+1)
		puts "going:"
		printNivel(nivel+2)
		puts "#{@token.str}"

		printNivel(nivel+1)
		puts "instruction:"

		if simbolo then
			$tablasDeSimbolos[$cantidadTablas].printTabla(nivel+2)
		end

		if @instDec != nil then
			@instDec.printNodo(nivel+2, simbolo)
		end
	end
end


class NodoWhile < NodoGeneral

	attr_accessor :repeat, :instDec1, :expresion, :dow, :instDec2

	def initialize(repeat, instDec1, expresion, dow, instDec2)
		@repeat = repeat
		@instDec1 = instDec1
		@expresion = expresion
		@dow = dow
		@instDec2 = instDec2
	end

	def printNodo(nivel, simbolo)
		printNivel(nivel)
		puts "WHILE"

		if @repeat != nil then
			printNivel(nivel+1)
			puts "repeat:"

			if @instDec1 != nil then
				@instDec1.printNodo(nivel+2, simbolo)
			end
		end

		printNivel(nivel+1)
		puts "condition:"
		@expresion.printNodo(nivel+2, simbolo)

		if @dow != nil then
			printNivel(nivel+1)
			puts "do:"

			if @instDec2 != nil then
				@instDec2.printNodo(nivel+2, simbolo)
			end
		end
	end
end


class NodoId < NodoGeneral

	attr_accessor :valor, :line, :column

	def initialize(valor)
		@valor = valor
		@line = valor.line
		@column = valor.column
	end

	def printNodo(nivel, simbolo)
		printNivel(nivel)
		puts "variable: #{@valor.str}"
	end
end


class NodoInt < NodoGeneral

	attr_accessor :valor, :line, :column

	def initialize(valor)
		@valor = valor
		@line = valor.line
		@column = valor.column
	end

	def printNodo(nivel, simbolo)
		printNivel(nivel)
		puts "const_int: #{@valor.str}"
	end
end


class NodoBool < NodoGeneral

	attr_accessor :valor, :line, :column

	def initialize(valor)
		@valor = valor
		@line = valor.line
		@column = valor.column
	end

	def printNodo(nivel, simbolo)
		printNivel(nivel)
		puts "const_bool: #{@valor.str}"
	end
end


class NodoBits < NodoGeneral

	attr_accessor :valor, :line, :column, :tamanio

	def initialize(valor)
		@valor = valor
		@line = valor.line
		@column = valor.column
		@tamanio = valor.str.length - 2
	end

	def printNodo(nivel, simbolo)
		printNivel(nivel)
		puts "const_bits: #{@valor.str}"
	end
end


class NodoStr < NodoGeneral

	attr_accessor :valor, :line, :column

	def initialize(valor)
		@valor = valor
		@line = valor.line
		@column = valor.column
	end

	def printNodo(nivel, simbolo)
		printNivel(nivel)
		puts "const_str: #{@valor.str}"
	end
end