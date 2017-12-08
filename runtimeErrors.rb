=begin

runtimeErrors.rb

Descripcion: Errores de ejecucion del lenguaje de programacion Bitiondo 

Autores:
	Lautaro Villalon. 12-10427
	Yarima Luciani. 13-10770

=end

class ErrorEjecucion

	def initialize(nodo, tipoError, info)
		@nodo = nodo
		@tipoError = tipoError
		@info = info
	end

	def to_s 
		case @tipoError
			# ERROR DE ASIGNACION ACCESO A POSICION INEXISTENTE 
			when "Error de asignacion acceso a posicion inexistente" #NodoExpresion
				puts "Error en línea #{@nodo.line}, columna #{@nodo.column}: La posición no existe en el arreglo de bits."
			
			# ERROR DE ASIGNACION A POSICION DE BITARRAY  
			when "Error de asignacion a posicion de bitarray" #NodoExpresion
				puts "Error en línea #{@nodo.line}, columna #{@nodo.column}: A una posicion del arreglo de bits no se le puede asignar un valor distinto a '0' o '1'."

			# ERROR DE DIVISION POR CERO:
			when "Error de division por cero" #NodoExpresion
				puts "Error en línea #{@nodo.line}, columna #{@nodo.column}: El divisor no puede ser '0'."
			
			# ERROR DE ENTEROS NEGATIVOS @
			when "Error de enteros negativos" #NodoExpresion
				puts "Error en línea #{@nodo.line}, columna #{@nodo.column}: El operador '#{@nodo.opUnario.operador.str}' no funciona con enteros negativos."

			# ERROR DE NUMERO QUE OCUPA MAS DE 32 BITS @  
			when "Error de numero que ocupa mas de 32 bits" #NodoExpresion
				puts "Error en línea #{@nodo.line}, columna #{@nodo.column}: El número no se puede representar en un arreglo de 32 bits."

			
			# ERRORES DE TAMANIO:
			when "Error de longitud de bits: inicializacion negativa" #NodoExpresion
				puts "Error en línea #{@nodo.line}, columna #{@nodo.column}: Inicialización de arreglo de bits no puede tener un tamaño negativo."

			when "Error de longitud de bits: inicializacion" #NodoExpresion
				puts "Error en línea #{@nodo.line}, columna #{@nodo.column}: Inicialización espera una expresión 'bits' de tamaño #{@info}."

			when "Error de longitud de bits: asignacion" #NodoExpresion
				puts "Error en línea #{@nodo.line}, columna #{@nodo.column}: Asignación espera una expresión 'bits' de tamaño #{@info}."

			when "Error de longitud de bits: expresion" #NodoExpresionBin
				puts "Error en línea #{@nodo.line}, columna #{@nodo.column}: Operador '#{@nodo.opBinario.operador.str}' espera expresiones 'bits' del mismo tamaño."

			when "Error de longitud de bits: expresion BitsInt" #NodoExpresionBin
				if @nodo.opBinario.operador == "ACCESS" then
					puts "Error en línea #{@nodo.line}, columna #{@nodo.column}: Operador '#{@nodo.opBinario.operador}' espera expresión 'int' menor o igual al tamaño de la expresión 'bits'."
				else
					puts "Error en línea #{@nodo.line}, columna #{@nodo.column}: Operador '#{@nodo.opBinario.operador.str}' espera expresión 'int' menor o igual al tamaño de la expresión 'bits'."
				end

			when "Error de longitud de bits: expresion dollar"
				puts "Error en línea #{@nodo.line}, columna #{@nodo.column}: Operador '#{@nodo.opUnario.operador.str}' espera expresiones 'bits' de tamaño '32'."

		end

		exit(1)
	end
end