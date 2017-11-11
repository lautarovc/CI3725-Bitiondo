
=begin

Lexer.rb

Descripcion: Lexer del lenguaje de programacion Bitiondo 

Autores:
	Lautaro Villalon. 12-10427
	Yarima Luciani. 13-10770

=end


# Token
# Clase que define un token
class Token

	attr_accessor :str, :line, :column, :type

	# initialize
	# Funcion que inicializa los valores de los atributos de la clase Token
	# Parametros de entrada: str, line, column
	def initialize(str, line, column)

		@contador = 0
		@str = str
		@line = line
		@column = column
		@hasValue = false
		@type = tokenIdentifier()
		
	end


	# tokenIdentifier
	# Funcion que determina el tipo de token
	# Parametros de entrada: token
	# Parametros de salida: string con el tipo de token
	def tokenIdentifier()

		regexDic =   {"Spaces": /\A(\s)+/,
					  "reserved": /\Abegin\b | \Aend\b  | \Aint\b  | \Abool\b  | \Abits\b  | \Ainput\b  | \Aoutput\b  | \Aoutputln\b  | \Aif\b  |
					               \Aelse\b  | \Afor\b  | \Aforbits\b  | \Aas\b  | \Afrom\b  | \Agoing\b  | \Ahigher\b  | \Alower\b  | \Arepeat\b  |
					               \Awhile\b | \Ado\b/x,
					  "boolean": /\Atrue\b | \Afalse\b/x,
					  "identifier": /\A[a-zA-Z][a-zA-Z0-9_]*/,
					  "bit array": /\A0b[01]+/,
					  "integer": /\A(\d)+/,
					  "string": /\A"(\\.|[^\\\"\n])*"/,
					  "left bracket": /\A\[/,
					  "right bracket": /\A\]/,
					  "not bits": /\A\~/,
					  "dollar": /\A\$/,
					  "at": /\A\@/,
					  "minus": /\A\-/,
					  "product": /\A\*/,
					  "division": /\A\//,
					  "module": /\A\%/,
					  "plus": /\A\+/,
					  "left displacement": /\A\<\</,
					  "right displacement": /\A\>\>/,
					  "less or equal than": /\A\<\=/,
					  "more or equal than": /\A\>\=/,
					  "less than": /\A\</,
					  "more than": /\A\>/,
					  "equals": /\A\=\=/,
					  "not equal": /\A\!\=/,
					  "not": /\A\!/,
					  "assign": /\A\=/,
					  "and": /\A\&\&/,
					  "or": /\A\|\|/,
					  "and bits": /\A\&/,
					  "xor bits": /\A\^/,
					  "or bits": /\A\|/,
					  "semicolon": /\A\;/,
					  "comma": /\A\,/,
					  "left parenthesis": /\A\(/,
					  "right parenthesis": /\A\)/                     
					 }

		regexDic.each do |key, regex|
			if (@str =~ regex)
				keyStr = key.to_s

				if (keyStr == "identifier" || keyStr == "bit array" || keyStr == "integer" || keyStr == "string" || keyStr == "boolean")
					@hasValue = true
					return keyStr

				elsif (keyStr =="reserved")
					return @str

				end

				return keyStr
			end
		end

		return "error"
	end



	# toString
	# Funcion que imprime el token encontrado en pantalla 
	# Parametros de entrada: token
	# Parametros de salida: impresion en pantalla
	def toString()

		if (@type == "error")
			puts "Error: Se encontró un caracter inesperado \"#{@str}\" en la Línea #{@line}, Columna #{@column}."


		elsif (@hasValue)
			puts "#{@type} at line #{@line}, column #{@column} with value `#{@str}`"

		else
			puts "#{@type} at line #{@line}, column #{@column}"

		end
	end

end


# Lexer
# Clase que hace el analisis lexico de un archivo en Bitiondo
class Lexer

	attr_accessor :tokens, :errorList

	# initialize
	# Funcion que inicializa los valores de los atributos de la clase Lexer
	# Parametros de entrada: file
	def initialize(file) 

		@file = file
		@tokens = []
		@errorList = []
	end

	# leer
	# Funcion que lee el archivo file y recolecta los tokens
	# Parametros de entrada: lexer
	def leer()
 
		superRegex = /\A\#.*                 							| 	# Comentario
					  \A(\s)+                  							|	# Espacios
					  \Atrue\b | \Afalse\b   							| 	# Constantes booleanas
					  \A[a-zA-Z][a-zA-Z0-9_]*  							| 	# Palabra
					  \A0b[01]+                							|	# Bits
					  \A(\d)+                  						    |	# Entero
					  \A"(\\.|[^\\"\n])*"      						    |   # Cadena de Caracteres
					  \A\[	|  \A\]	   									|   # Corchetes
					  \A\~                     							|   # Negacion bits 
					  \A\$                     							|   # Operador unario de bits dolar 
					  \A\@                     							|   # Operador unario de bits arroba
					  \A\-                     							|   # Negacion o resta 
					  \A\*                     							|   # Multiplicacion 
					  \A\/                     							|   # Division 
					  \A\%                     							|   # Modulo 
					  \A\+                     							|   # Suma
					  \A\<\<  |  \A\>\>    							    |   # Desplazamientos 
					  \A\<\= | \A\>\= | \A\< | \A\> | \A\=\= | \A\!\=   |   # Comparadores
					  \A\!                     							|   # Negacion 
					  \A\=												|	# Asignacion
					  \A\&\&                                            |   # Conjuncion 
					  \A\|\|                                            |   # Disyuncion
					  \A\&                                              |   # Conjuncion bits 
					  \A\^                                              |   # Disyuncion exclusiva bits 
					  \A\|                                              |   # Disyuncion bits 
					  \A\;                                              |   # Punto y coma 
					  \A\,                                              |   # Coma 
					  \A\( | \A\)                                           # Parentesis                      
					  /x

		error = false

		# LECTURA DE CADA LINEA DEL ARCHIVO
		for i in (0..(@file.length-1))

			# INICIALIZACION DE VARIABLES TEMPORALES DE LA LINEA
			prevLine = @file[i]
			tmp = Token.new("",1, 1)

			while (prevLine != "")

				# CALCULO DE LA POSICION DEL NUEVO TOKEN Y COMPARACION CON superRegex
				prevColumn = tmp.str.length + tmp.column
				relPosition = superRegex =~ prevLine

				# VERIFICACION DE ERROR
				if (relPosition == nil)
					error = true
					tmp = Token.new(prevLine[0], i+1, prevColumn)
					@errorList.push(tmp)
					
					prevLine = prevLine[1..-1]
					next
				end

				# VERIFICACION DE COMENTARIO
				if ($&[0] == "#")
					break
				end

				# ADICION DEL TOKEN A LA LISTA DE TOKENS CON SU POSICION ACTUALIZADA
				j = prevColumn + relPosition
				tmp = Token.new($&, i+1, j)
				@tokens.push(tmp)
				prevLine = $'
			end
		end

		# BORRAMOS ESPACIOS
		tokens.delete_if {|tok| tok.type == "Spaces"}

	end

	def next_token

end

