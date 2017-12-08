=begin

semanticErrors.rb

Descripcion: Errores semanticos del lenguaje de programacion Bitiondo 

Autores:
	Lautaro Villalon. 12-10427
	Yarima Luciani. 13-10770

=end

class ErrorSemantico

	def initialize(nodo, tipoError, info)
		@nodo = nodo
		@tipoError = tipoError
		@info = info
	end

	def to_s 
		case @tipoError
			when "Redeclaracion de variable dentro del bloque" # NodoId
				puts "Error en línea #{@nodo.line}, columna #{@nodo.column}: La variable '#{@nodo.valor.str}' ya ha sido declarada en este alcance."

			when "Utilizacion de variable no declarada"	# NodoId
				puts "Error en línea #{@nodo.line}, columna #{@nodo.column}: La variable '#{@nodo.valor.str}' no ha sido declarada en este alcance."

			when "Modificacion de variable de iteracion" #NodoId
				puts "Error en línea #{@nodo.line}, columna #{@nodo.column}: No es posible modificar la variable de iteración '#{@nodo.valor.str}'."

			when "Error de tipo: expresion binaria" #NodoExpresionBin 
				if @nodo.opBinario.operador.is_a?(Token) then
					puts "Error en línea #{@nodo.line}, columna #{@nodo.column}: Operador '#{@nodo.opBinario.operador.str}' no puede funcionar con expresiones de tipo '#{@info}'."

				elsif @nodo.opBinario.operador == "ACCESS" then
					puts "Error en línea #{@nodo.line}, columna #{@nodo.column}: Operador '#{@nodo.opBinario.operador}' no puede funcionar con expresiones de tipo '#{@info}'."
				end

			when "Error de tipo: expresion binaria BitsInt" #NodoExpresionBin
				if @nodo.opBinario.operador.is_a?(Token) then
					puts "Error en línea #{@nodo.line}, columna #{@nodo.column}: Operador '#{@nodo.opBinario.operador.str}' no puede funcionar con expresiones de tipo '#{@info[0]}' a su #{@info[1]}."

				elsif @nodo.opBinario.operador == "ACCESS" then
					puts "Error en línea #{@nodo.line}, columna #{@nodo.column}: Operador '#{@nodo.opBinario.operador}' no puede funcionar con expresiones de tipo '#{@info[0]}' a su #{@info[1]}."
				end

			when "Error de tipo: expresion binaria con operadores == o !=" #NodoExpresionBin
				puts "Error en línea #{@nodo.line}, columna #{@nodo.column}: Operador '#{@nodo.opBinario.operador.str}' no puede funcionar con expresiones de tipos distintos."

			when "Error de tipo: expresion unaria" #NodoExpresionUn
				if @nodo.opUnario.operador.is_a?(Token) then
					puts "Error en línea #{@nodo.line}, columna #{@nodo.column}: Operador '#{@nodo.opUnario.operador.str}' no puede funcionar con expresiones de tipo '#{@info}'."
				elsif @nodo.opUnario.operador == "ACCESS" then
					puts "Error en línea #{@nodo.line}, columna #{@nodo.column}: Operador '#{@nodo.opUnario.operador}' no puede funcionar con expresiones de tipo '#{@info}'."
				end

			when "Error de tipo: condicion del if" #NodoExpresion
				puts "Error en línea #{@nodo.line}, columna #{@nodo.column}: Instrucción 'if' espera expresión de tipo 'bool' en la condición."

			when "Error de tipo: condicion del for" #NodoExpresion
				puts "Error en línea #{@nodo.line}, columna #{@nodo.column}: Instrucción 'for' espera expresión de tipo 'bool' en la condición."

			when "Error de tipo: valor de paso del for" #NodoExpresion
				puts "Error en línea #{@nodo.line}, columna #{@nodo.column}: Instrucción 'for' espera expresión de tipo 'int' en el valor de paso."

			when "Error de tipo: expresion bits del forbits" #NodoExpresion
				puts "Error en línea #{@nodo.line}, columna #{@nodo.column}: Instrucción 'forbits' espera expresión de tipo 'bits' en el forbits."

			when "Error de tipo: expresion int del forbits" #NodoExpresion
				puts "Error en línea #{@nodo.line}, columna #{@nodo.column}: Instrucción 'forbits' espera expresión de tipo 'int' en el from."

			when "Error de tipo: condicion del while" #NodoExpresion
				puts "Error en línea #{@nodo.line}, columna #{@nodo.column}: Instrucción 'while' espera expresión de tipo 'bool' en la condición."

			when "Error de tipo: inicializacion de tipo distinto" #NodoExpresion
				puts "Error en línea #{@nodo.line}, columna #{@nodo.column}: Inicialización espera una expresión de tipo '#{@info[0]}'."

			when "Error de tipo: asignacion de tipo distinto" #NodoExpresion		
				puts "Error en línea #{@nodo.line}, columna #{@nodo.column}: Asignación espera una expresión de tipo '#{@info[0]}'."

			when "Error de tipo: asignacion de acceso" #NodoExpresion
				puts "Error en línea #{@nodo.line}, columna #{@nodo.column}: Operador 'ACCESS' no puede funcionar con expresiones de tipo '#{@info}' a su izquierda."

			when "Error de tipo: valor de la posicion de acceso" #NodoExpresion
				puts "Error en línea #{@nodo.line}, columna #{@nodo.column}: El valor de la posición del operador 'ACCESS' no puede ser de tipo '#{@info}'."


			# ERRORES DE TAMANIO:

			# when "Error de longitud de bits: inicializacion" #NodoExpresion
			# 	puts "Error en línea #{@nodo.line}, columna #{@nodo.column}: Inicialización espera una expresión 'bits' del mismo tamaño."

			# when "Error de longitud de bits: asignacion" #NodoExpresion
			# 	puts "Error en línea #{@nodo.line}, columna #{@nodo.column}: Asignación espera una expresión 'bits' del mismo tamaño."

			# when "Error de longitud de bits: expresion" #NodoExpresionBin
			# 	puts "Error en línea #{@nodo.line}, columna #{@nodo.column}: Operador '#{@nodo.opBinario.operador.str}' espera expresiones 'bits' del mismo tamaño."

			# when "Error de longitud de bits: expresion dollar"
			# 	puts "Error en línea #{@nodo.line}, columna #{@nodo.column}: Operador '#{@nodo.opUnario.operador.str}' espera expresiones 'bits' de tamaño '32'."

		end

		exit(1)
	end
end