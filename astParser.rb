=begin

Lexer.rb

Descripcion: AST del parser del lenguaje de programacion Bitiondo 

Autores:
	Lautaro Villalon. 12-10427
	Yarima Luciani. 13-10770

=end


class nodoGeneral;
	def printNivel(num)
		for i in 1..num
			print "\t"
		end
	end
end


#class nodoInstruccion < nodoGeneral; end
#class nodoExpresion < nodoGeneral; end
#class nodoExpresionBinaria < nodoGeneral; end
#class nodoExpresionUnaria < nodoGeneral; end


class nodoInicial < nodoGeneral

	attr_accessor :bloquePrincipal

	def initialize(bloquePrincipal = nil)
		@nivel = 0
		@bloquePrincipal = bloquePrincipal
	end

	def printNodo()
		puts "BEGIN"
		puts

		if @bloquePrincipal != nil then
			@bloquePrincipal.printNodo(@nivel+1)
		end
		puts
		puts "END"
	end
end


class nodoBloquePrincipal < nodoGeneral

	attr_accessor :declaraciones, :instrucciones

	def initialize(declaraciones = nil, instrucciones = nil)
		@declaraciones = declaraciones
		@instrucciones = instrucciones
	end

	def printNodo(nivel)
		@declaraciones.printNodo(nivel)
		@instrucciones.printNodo(nivel)
	end


class nodoBloques < nodoGeneral

	attr_accessor :bloquePrincipal

	def initialize(bloquePrincipal = nil)
		@bloquePrincipal = bloquePrincipal
	end

	def printNodo(nivel)
		printNivel(nivel)
		puts "BEGIN"

		if @bloquePrincipal != nil then
			@bloquePrincipal.printNodo(nivel+1)
		end

		printNivel(nivel)
		puts "END"
	end
end

class nodoDeclaraciones < nodoGeneral

	attr_accessor :declaracion, :declaraciones

	def initialize(declaracion = nil, declaraciones = nil)
		@declaracion = declaracion
		@declaraciones = declaraciones
	end

	def printNodo(nivel)

		if @declaracion != nil then
			@declaracion.printNodo(nivel)
		end

		if @declaraciones != nil then
			@declaraciones.printNodo(nivel)
		end

	end
end

class nodoDeclaracion < nodoGeneral

	attr_accessor :tipo, :id, :tamanio, :asignacion

	def initialize(tipo, id, tamanio = nil, asignacion = nil)
		@tipo = tipo
		@id = id
		@tamanio = tamanio
		@asignacion = asignacion
	end

	def printNodo(nivel)

		printNivel(nivel)
		puts "DECLARE"
		nivel = nivel + 1

		printNivel(nivel)
		puts "type: #{@tipo.str}"

		@id.printNodo(nivel)

		if @tamanio != nil then
			printNivel(nivel)
			puts "size:"
			@tamanio.printNodo(nivel+1)
		end

		if @asignacion != null then
			printNivel(nivel)
			puts "value:"
			@asignacion.printNodo(nivel+1)
	end

end


class nodoInit < nodoGeneral

	attr_accessor :valor

	def initialize(valor)
		@valor = valor
	end

	def printNodo(nivel)
		@valor.printNodo(nivel)
	end
end


class nodoInstrucciones < nodoGeneral

	attr_accessor :instruccion, :instrucciones

	def initialize(instruccion = nil, instrucciones = nil)
		@instruccion = instruccion
		@instrucciones = instrucciones
	end

	def printNodo(nivel)

		if @instruccion != nil then
			@instruccion.printNodo(nivel)
		end

		if @instrucciones != nil then
			@instrucciones.printNodo(nivel)
		end

	end
end

class nodoInstruccion < nodoGeneral

	attr_accessor :instruccion

	def initialize(instruccion = nil)
		@instruccion = instruccion
	end

	def printNodo(nivel)
		@instruccion.printNodo(nivel)
	end

end

class nodoExpresionBin < nodoGeneral

	attr_accessor :expresion1, :opBinario, :expresion2

	def initialize(expresion1, opBinario, expresion2)
		@expresion1 = expresion1
		@opBinario = opBinario
		@expresion2 = expresion2
	end

	def printNodo(nivel)
		printNivel(nivel)
		puts "BIN_EXPRESSION:"
		@opBinario.printNodo(nivel+1)

		printNivel(nivel+1)
		puts "left operand:"
		@expresion1.printNodo(nivel+2)

		printNivel(nivel+1)
		puts "right operand:"
		@expresion2.printNodo(nivel+2)

	end
end

class nodoExpresionUn < nodoGeneral

	attr_accessor :opUnario, :expresion

	def initialize(opUnario, expresion)
		@opUnario = opUnario
		@expresion = expresion
	end

	def printNodo(nivel)
		printNivel(nivel)
		puts "UN_EXPRESSION:"
		@opUnario.printNodo(nivel+1)

		printNivel(nivel+1)
		puts "operand:"
		@expresion.printNodo(nivel+2)

	end
end


class nodoOperador < nodoGeneral

	attr_accessor :operador

	def initialize(operador)
		@operador = operador
	end

	def printNodo(nivel)
		printNivel(nivel)
		puts "operator: #{@operador.type}"
	end
end


class nodoAsignacion < nodoGeneral

	attr_accessor :id, :expresion

	def initialize(id, expresion)
		@id = id
		@expresion = expresion
	end

	def printNodo(nivel)
		printNivel(nivel)
		puts "ASSIGN"

		@id.printNodo(nivel+1)

		printNivel(nivel+1)
		puts "value:"

		@expresion.printNodo(nivel+2)
	end
end


class nodoEntrada < nodoGeneral

	attr_accessor :id

	def initialize(id)
		@id = id
	end

	def printNodo(nivel)
		printNivel(nivel)
		puts "INPUT"

		@id.printNodo(nivel+1)
	end
end


class nodoSalida < nodoGeneral

	attr_accessor :token, :expMult

	def initialize(id)
		@token = token
		@expMult = expMult
	end

	def printNodo(nivel)
		printNivel(nivel)
		puts "#{token.str}"

		printNivel(nivel+1)
		puts "elements:"

		@expMult.printNodo(nivel+2)
	end
end


class nodoExpMultiple < nodoGeneral

	attr_accessor :expresion, :expMultiple

	def initialize(expresion = nil, expMultiple = nil)
		@expresion = expresion
		@expMultiple = expMultiple
	end

	def printNodo(nivel)

		if @expresion != nil then
			@expresion.printNodo(nivel)
		end

		if @expMultiple != nil then
			@expMultiple.printNodo(nivel)
		end

	end
end


class nodoCondicional < nodoGeneral

	attr_accessor :expresion, :instDec, :clausuraElse

	def initialize(expresion, instDec = nil, clausuraElse = nil)
		@expresion = expresion
		@instDec = instDec
		@clausuraElse = clausuraElse
	end

	def printNodo(nivel)
		printNivel(nivel)
		puts "IF"

		printNivel(nivel+1)
		puts "condition:"

		@expresion.printNodo(nivel+2)

		printNivel(nivel+1)
		puts "instruction:"

		if @instDec != nil then
			@instDec.printNodo(nivel+2)
		end

		if @clausuraElse != nil then
			@clausuraElse.printNodo(nivel+1)
		end
	end
end


class nodoClausuraElse < nodoGeneral

	attr_accessor :instDec

	def initialize(instDec = nil)
		@instDec = instDec
	end

	def printNodo(nivel)
		printNivel(nivel)
		puts "ELSE"

		printNivel(nivel+1)
		puts "instruction:"

		if @instDec != nil then
			@instDec.printNodo(nivel+2)
		end
	end
end


class nodoFor < nodoGeneral

	attr_accessor :asignacion, :expresion1, :expresion2, :instDec

	def initialize(asignacion, expresion1, expresion2, instDec = nil)
		@asignacion = asignacion
		@expresion1 = expresion1
		@expresion2 = expresion2
		@instDec = instDec
	end

	def printNodo(nivel)
		printNivel(nivel)
		puts "FOR"

		@asignacion.printNodo(nivel+1)

		@expresion1.printNodo(nivel+1)

		@expresion2.printNodo(nivel+1)

		printNivel(nivel+1)
		puts "instruction:"

		if @instDec != nil then
			@instDec.printNodo(nivel+2)
		end
	end
end


class nodoForBits < nodoGeneral

	attr_accessor :expresion1, :id, :expresion2, :token, :instDec

	def initialize(expresion1, id, expresion2, token, instDec = nil)
		@expresion1 = expresion1
		@id = id
		@expresion2 = expresion2
		@token = token
		@instDec = instDec
	end

	def printNodo(nivel)
		printNivel(nivel)
		puts "FOR BITS"

		printNivel(nivel+1)
		puts "value:"
		@expresion1.printNodo(nivel+2)

		printNivel(nivel+1)
		puts "as:"
		@id.printNodo(nivel+2)

		printNivel(nivel+1)
		puts "from:"
		@expresion2.printNodo(nivel+2)

		printNivel(nivel+1)
		puts "going: #{@token.str}"

		printNivel(nivel+1)
		puts "instruction:"

		if @instDec != nil then
			@instDec.printNodo(nivel+2)
		end
	end
end


class nodoWhile < nodoGeneral

	attr_accessor :repeat, :instDec1, :expresion, :do, :instDec2

	def initialize(repeat = nil, instDec1 = nil, expresion, dow = nil, instDec2 = nil)
		@repeat = repeat
		@instDec1 = instDec1
		@expresion = expresion
		@dow = dow
		@instDec2 = instDec2
	end

	def printNodo(nivel)
		printNivel(nivel)
		puts "WHILE"

		if @repeat != nil then
			printNivel(nivel+1)
			puts "repeat:"

			if @instDec1 != nil then
				@instDec1.printNodo(nivel+2)
			end
		end

		printNivel(nivel+1)
		puts "condition:"
		@expresion.printNodo(nivel+2)

		if @dow != nil then
			printNivel(nivel+1)
			puts "do:"

			if @instDec2 != nil then
				@instDec2.printNodo(nivel+2)
			end
		end
	end
end


class nodoId < nodoGeneral

	attr_accessor :valor

	def initialize(valor)
		@valor = valor
	end

	def printNodo(nivel)
		printNivel(nivel)
		puts "variable: #{@valor.str}"
	end
end


class nodoInt < nodoGeneral

	attr_accessor :valor

	def initialize(valor)
		@valor = valor
	end

	def printNodo(nivel)
		printNivel(nivel)
		puts "const_int: #{@valor.str}"
	end
end


class nodoBool < nodoGeneral

	attr_accessor :valor

	def initialize(valor)
		@valor = valor
	end

	def printNodo(nivel)
		printNivel(nivel)
		puts "const_bool: #{@valor.str}"
	end
end


class nodoBits < nodoGeneral

	attr_accessor :valor

	def initialize(valor)
		@valor = valor
	end

	def printNodo(nivel)
		printNivel(nivel)
		puts "const_bits: #{@valor.str}"
	end
end


class nodoStr < nodoGeneral

	attr_accessor :valor

	def initialize(valor)
		@valor = valor
	end

	def printNodo(nivel)
		printNivel(nivel)
		puts "const_str: #{@valor.str}"
	end
end