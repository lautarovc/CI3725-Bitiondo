=begin

symbolTable.rb

Descripcion: Tabla de simbolos del lenguaje de programacion Bitiondo 

Autores:
	Lautaro Villalon. 12-10427
	Yarima Luciani. 13-10770

=end

class TablaSimbolos

	attr_accessor :id

	# initialize 
	# Funcion que inicializa la tabla de simbolos
	# Parametros de entrada: id
	def initialize(id = nil)
		@id = id
		@tabla = Hash.new
		@tamanio = Hash.new
		@asignacion = Hash.new
		@modificable = Hash.new
	end


	# insertar
	# Funcion que inserta un elemento dentro de la tabla de simbolos
	# Parametros de entrada: identificador, tipo, tamanio, asignacion, modificable
	def insertar(identificador, tipo, tamanio, asignacion, modificable = true)
		@tabla.store(identificador.valor.str, tipo)

		if tamanio != nil then
			@tamanio.store(identificador.valor.str, tamanio)
		end

		if asignacion != nil then
			@asignacion.store(identificador.valor.str, asignacion)

		else

			if tipo.str == "int" then
				# token = Token.new("0", -1, -1)
				# nodo = NodoInt.new(token)
				@asignacion.store(identificador.valor.str, 0)

			elsif tipo.str == "bool" then
				# token = Token.new("false", -1, -1)
				# nodo = NodoBool.new(token)
				@asignacion.store(identificador.valor.str, false)

			elsif tipo.str == "bits" && (tamanio.is_a?(Integer) || tamanio.is_a?(String)) then

				i = 0
				valor = "0b"
				while (i<Integer(tamanio))
					valor += "0"
					i += 1
				end

				@asignacion.store(identificador.valor.str, valor)

			end

		end

		@modificable.store(identificador.valor.str, modificable)

	end

	# eliminar
	# Funcion que elimina un elemento de la tabla de simbolos
	# Parametros de entrada: identificador
	def eliminar(identificador)
		@tabla.delete(identificador)
		@tamanio.delete(identificador)
	end 

	# actualizar
	# Funcion que actualiza un elemento que se encuentra en la tabla de simbolos
	# Parametros de entrada: identificador, tipo, tamanio, asignacion
	def actualizar(identificador, tipo, tamanio, asignacion)
		@tabla.store(identificador.valor.str, tipo)

		if tamanio != nil then
			@tamanio.store(identificador.valor.str, tamanio)
		end

		if asignacion != nil then
			@asignacion.store(identificador.valor.str, asignacion)
		end
	end

	# contiene
	# Funcion que determina si un elemento se encuentra en la tabla de simbolos
	# Parametros de entrada: identificador
	# Parametros de salida: esta 
	def contiene(identificador)
		esta = @tabla.has_key?(identificador)

		return esta
	end

	# encontrar
	# Funcion que devuelve la informacion de un elemento en la tabla de simbolos suponiendo que dicho elemento existe
	# Parametros de entrada: identificador
	def encontrar(identificador)
		if self.contiene(identificador) then
			resultado = [@tabla[identificador], @tamanio[identificador], @asignacion[identificador]]
			return resultado
		end

		return nil
	end

	# esModificable
	# Funcion que verifica si un elemento de la tabla de simbolos se puede modificar o no
	# Parametros de entrada: identificador 
	def esModificable(identificador)
		modificable = @modificable[identificador]

		return modificable
	end

	# printNivel
	# Funcion que imprime la identacion del ast
	# Parametros de entrada: num 
	def printNivel(num)
		for i in 1..num
			print "    "
		end
	end

	# printTabla
	# Funcion que imprime una tabla de simbolos 
	# Parametros de entrada: nivel
	def printTabla(nivel)
		printNivel(nivel)
		puts "SYMBOL TABLE"

		@tabla.each do |identificador, valor|
			printNivel(nivel+1)
			puts "Name: #{identificador}, Type: #{valor.str}"
		end
	end

	def tieneTamanio(identificador)
		tiene = @tamanio.has_key?(identificador)

		return tiene
	end

	def tieneAsignacion(identificador)
		tiene = @asignacion.has_key?(identificador)

		return tiene
	end

	def actualizarAsignacion(identificador, asignacion)

		if asignacion != nil then
			@asignacion.store(identificador.valor.str, asignacion)
		end
	end

end