=begin

semanticAnalyzer.rb

Descripcion: Analizador semantico del lenguaje de programacion Bitiondo 

Autores:
	Lautaro Villalon. 12-10427
	Yarima Luciani. 13-10770

=end

require_relative 'symbolTable.rb'
require_relative 'semanticErrors.rb'

class AnalizadorSemantico

	attr_accessor :errores, :tablasSimbolos

	def initialize(nodoInicial)
		@errores = []
		@tablasSimbolos = []
		@nodoInicial = nodoInicial
		@contadorTablas = -1 
	end

	def analizar()
		if @nodoInicial.bloquePrincipal != nil then
			manejadorBloquePrincipal(@nodoInicial.bloquePrincipal)
		end
	end

	def manejadorBloquePrincipal(nodoBloquePrincipal)
		if nodoBloquePrincipal.declaraciones != nil then
			@contadorTablas = @contadorTablas + 1

			tabla = TablaSimbolos.new @contadorTablas
			tablasSimbolos.push(tabla)

			manejadorDeclaraciones(nodoBloquePrincipal.declaraciones, @contadorTablas)

		end

		if nodoBloquePrincipal.instrucciones != nil then
			manejadorInstrucciones(nodoBloquePrincipal.instrucciones, @contadorTablas)
		end

		if nodoBloquePrincipal.declaraciones != nil then
			#tablasSimbolos[@contadorTablas].printTabla(0)
			@tablasSimbolos.pop()
			@contadorTablas = @contadorTablas - 1
		end
	end

	def manejadorDeclaraciones(nodoDeclaraciones, idTabla)

		manejadorDeclaracion(nodoDeclaraciones.declaracion, idTabla)

		if nodoDeclaraciones.declaraciones != nil then
			manejadorDeclaraciones(nodoDeclaraciones.declaraciones, idTabla)
		end
	end

	def manejadorDeclaracion(nodoDeclaracion, idTabla)
		if tablasSimbolos[idTabla].contiene(nodoDeclaracion.id.valor.str) then
			tipoExistente = tablasSimbolos[idTabla].encontrar(nodoDeclaracion.id.valor.str)[0]
			# tipoNuevo = nodoDeclaracion.tipo
			# if tipoExistente.str == tipoNuevo.str then
			# 	#ERROR DE REDECLARACION
			# 	error = ErrorSemantico.new(nodoDeclaracion.id, "Redeclaracion de variable dentro del bloque", nil)
			# 	@errores.push(error)
			# else 
			# 	tablasSimbolos[idTabla].actualizar(nodoDeclaracion.id, nodoDeclaracion.tipo, nodoDeclaracion.tamanio, nodoDeclaracion.asignacion)
			# end

			if tipoExistente != nil then
				#ERROR DE REDECLARACION
			 	error = ErrorSemantico.new(nodoDeclaracion.id, "Redeclaracion de variable dentro del bloque", nil)
			 	@errores.push(error)
			 end
		end

		if nodoDeclaracion.asignacion != nil then

			manejadorExpresion(nodoDeclaracion.asignacion.valor, idTabla)

			if nodoDeclaracion.asignacion.valor.is_a?(NodoExpresionBin) || nodoDeclaracion.asignacion.valor.is_a?(NodoExpresionUn) then

				if !chequeoTipoEquivalente(nodoDeclaracion.tipo, nodoDeclaracion.asignacion.valor.tipoResultado) then
					# ERROR DE TIPO DE ASIGNACION
					error = ErrorSemantico.new(nodoDeclaracion.asignacion.valor, "Error de tipo: inicializacion de tipo distinto", [nodoDeclaracion.tipo.str])
					@errores.push(error)
				end

			elsif nodoDeclaracion.asignacion.valor.is_a?(NodoId) then
				tipoAsignado = encontrarTipoTablas(nodoDeclaracion.asignacion.valor.valor.str, idTabla)
				tipoExistente = nodoDeclaracion.tipo.str

				if tipoAsignado != nil && tipoAsignado.str != tipoExistente then
					error = ErrorSemantico.new(nodoDeclaracion.asignacion.valor, "Error de tipo: inicializacion de tipo distinto", [nodoDeclaracion.tipo.str])
					@errores.push(error)
				end	

			else
				if !chequeoTipoEquivalente(nodoDeclaracion.tipo, nodoDeclaracion.asignacion.valor.valor.type) then
					# ERROR DE TIPO DE ASIGNACION
					error = ErrorSemantico.new(nodoDeclaracion.asignacion.valor, "Error de tipo: inicializacion de tipo distinto", [nodoDeclaracion.tipo.str])
					@errores.push(error)
				end

			end

		end

		if nodoDeclaracion.tamanio != nil then
			tipoTamanio = tipoExpresion(nodoDeclaracion.tamanio, idTabla)
			manejadorExpresion(nodoDeclaracion.tamanio, idTabla)

			if tipoTamanio != nil && tipoTamanio.upcase != "INT" then
				# ERROR DE ACCESO: POSICION DE TIPO NO INT
				error = ErrorSemantico.new(nodoDeclaracion.tamanio, "Error de tipo: valor de la posicion de acceso", tipoTamanio.downcase)
				@errores.push(error)

			end
		end

		tablasSimbolos[idTabla].insertar(nodoDeclaracion.id, nodoDeclaracion.tipo, nodoDeclaracion.tamanio, nodoDeclaracion.asignacion)
	end

	def manejadorInstrucciones(nodoInstrucciones, idTabla)
		manejadorInstruccion(nodoInstrucciones.instruccion, idTabla)

		if nodoInstrucciones.instrucciones != nil then
			manejadorInstrucciones(nodoInstrucciones.instrucciones, idTabla)
		end
	end

	def manejadorInstruccion(nodoInstruccion, idTabla)
		if nodoInstruccion.instruccion.is_a?(NodoAsignacion) then
			manejadorAsignacion(nodoInstruccion.instruccion, idTabla)

		elsif nodoInstruccion.instruccion.is_a?(NodoEntrada) then
			manejadorEntrada(nodoInstruccion.instruccion, idTabla)

		elsif nodoInstruccion.instruccion.is_a?(NodoSalida) then
			manejadorSalida(nodoInstruccion.instruccion, idTabla)

		elsif nodoInstruccion.instruccion.is_a?(NodoCondicional) then
			manejadorCondicional(nodoInstruccion.instruccion, idTabla)

		elsif nodoInstruccion.instruccion.is_a?(NodoFor) then
			manejadorFor(nodoInstruccion.instruccion, idTabla) 

		elsif nodoInstruccion.instruccion.is_a?(NodoForBits) then
			manejadorForBits(nodoInstruccion.instruccion, idTabla)

		elsif nodoInstruccion.instruccion.is_a?(NodoWhile) then
			manejadorWhile(nodoInstruccion.instruccion, idTabla)

		elsif nodoInstruccion.instruccion.is_a?(NodoInicial) then
			if nodoInstruccion.instruccion.bloquePrincipal != nil then
				manejadorBloquePrincipal(nodoInstruccion.instruccion.bloquePrincipal)
			end
		end
	end

	def manejadorAsignacion(nodoAsignacion, idTabla)

		manejadorId(nodoAsignacion.id, idTabla)

		tipo = encontrarTipoTablas(nodoAsignacion.id.valor.str, idTabla)

		if tipo != nil && !encontrarModificableTablas(nodoAsignacion.id.valor.str, idTabla) then
			# ERROR DE MODIFICACION DE VARIABLE DE ITERACION
			error = ErrorSemantico.new(nodoAsignacion.id, "Modificacion de variable de iteracion", nil)
			@errores.push(error)
		end

		if tipo != nil && tipo.str != "bits" && nodoAsignacion.posicion != nil then
			# ERROR DE ACCESO A TIPO DISTINTO DE BITS
			error = ErrorSemantico.new(nodoAsignacion.id, "Error de tipo: asignacion de acceso", tipo.str.downcase)
			@errores.push(error)

		elsif tipo != nil && tipo.str == "bits" && nodoAsignacion.posicion != nil then
			tokenTipo = Token.new("int", tipo.line, tipo.column)
			tipo = tokenTipo
		end

		if tipo != nil && nodoAsignacion.posicion != nil then
			tipoPosicion = tipoExpresion(nodoAsignacion.posicion, idTabla)
			manejadorExpresion(nodoAsignacion.posicion, idTabla)

			if tipoPosicion != nil && tipoPosicion.upcase != "INT" then
				# ERROR DE ACCESO: POSICION DE TIPO NO INT
				error = ErrorSemantico.new(nodoAsignacion.posicion, "Error de tipo: valor de la posicion de acceso", tipoPosicion.downcase)
				@errores.push(error)
			end
		end



		manejadorExpresion(nodoAsignacion.expresion, idTabla)

		if nodoAsignacion.expresion.is_a?(NodoId) then
			tipo2 = encontrarTipoTablas(nodoAsignacion.expresion.valor.str, idTabla)

			if tipo != nil && tipo2 != nil && tipo.str != tipo2.str then
				# ERROR DE TIPO, ASIGNACION
				error = ErrorSemantico.new(nodoAsignacion.expresion, "Error de tipo: asignacion de tipo distinto", [tipo.str])
				@errores.push(error)
			end

		elsif tipo != nil && (nodoAsignacion.expresion.is_a?(NodoExpresionBin) || nodoAsignacion.expresion.is_a?(NodoExpresionUn)) then

			if !chequeoTipoEquivalente(tipo, nodoAsignacion.expresion.tipoResultado) then
				# ERROR DE TIPO, ASIGNACION
				error = ErrorSemantico.new(nodoAsignacion.expresion, "Error de tipo: asignacion de tipo distinto", [tipo.str])
				@errores.push(error)

			end

		elsif tipo != nil then
			if !chequeoTipoEquivalente(tipo, nodoAsignacion.expresion.valor.type) then
				# ERROR DE TIPO, ASIGNACION
				error = ErrorSemantico.new(nodoAsignacion.expresion, "Error de tipo: asignacion de tipo distinto", [tipo.str])
				@errores.push(error)
			end

		end

		#ERROR DE TAMANIO: ASIGNACION DE TAMANIOS DIFERENTES

		# tamanioExistente = tamanioExpresion(nodoAsignacion.id, idTabla)

		# if tamanioExistente != "Error de Tamanio" then
			
		# 	tamanioAsignado = tamanioExpresion(nodoAsignacion.expresion, idTabla)
			
		# 	if tamanioAsignado != "Error de Tamanio" && tamanioExistente != tamanioAsignado then
		# 		# ERROR DE ASIGNACION TAMANIO BITS
		# 		error = ErrorSemantico.new(nodoAsignacion.expresion, "Error de longitud de bits: asignacion", nil)
		# 		@errores.push(error)
		# 	end
		# end
	end

	def manejadorEntrada(nodoEntrada, idTabla)
		manejadorId(nodoEntrada.id, idTabla)
	end

	def manejadorSalida(nodoSalida, idTabla)
		manejadorExpMultiple(nodoSalida.expMult, idTabla)		
	end

	def manejadorExpMultiple(nodoExpMultiple, idTabla)
		manejadorExpresion(nodoExpMultiple.expresion, idTabla)

		if nodoExpMultiple.expMultiple != nil then
			manejadorExpMultiple(nodoExpMultiple.expMultiple, idTabla)
		end
	end

	def manejadorExpresion(nodoExpresion, idTabla)
		if nodoExpresion.is_a?(NodoExpresionBin) then
			manejadorExpresionBin(nodoExpresion, idTabla)

		elsif nodoExpresion.is_a?(NodoExpresionUn) then
			manejadorExpresionUn(nodoExpresion, idTabla)

		elsif nodoExpresion.is_a?(NodoId) then
			manejadorId(nodoExpresion, idTabla)

		end
	end

	def manejadorExpresionBin(nodoExpresionBin, idTabla)

		manejadorExpresion(nodoExpresionBin.expresion1, idTabla)
		manejadorExpresion(nodoExpresionBin.expresion2, idTabla)

		tipoExpresion1 = tipoExpresion(nodoExpresionBin.expresion1, idTabla)
		tipoExpresion2 = tipoExpresion(nodoExpresionBin.expresion2, idTabla)

		if nodoExpresionBin.tipo == 'Aritmetica' then

			if tipoExpresion1 != nil && tipoExpresion1.upcase != 'INT' then
				#ERROR DE TIPO EXPRESION
				error = ErrorSemantico.new(nodoExpresionBin, "Error de tipo: expresion binaria", tipoExpresion1)
				@errores.push(error)
			end

			if tipoExpresion2 != nil && tipoExpresion2.upcase != 'INT' then
				#ERROR DE TIPO EXPRESION
				error = ErrorSemantico.new(nodoExpresionBin, "Error de tipo: expresion binaria", tipoExpresion2)
				@errores.push(error)
			end

		elsif nodoExpresionBin.tipo == 'Logica' then

			if tipoExpresion1 != nil && tipoExpresion1.upcase != 'BOOL' then
				#ERROR DE TIPO EXPRESION
				error = ErrorSemantico.new(nodoExpresionBin, "Error de tipo: expresion binaria", tipoExpresion1)
				@errores.push(error)
			end	

			if tipoExpresion2 != nil && tipoExpresion2.upcase != 'BOOL' then
				#ERROR DE TIPO EXPRESION
				error = ErrorSemantico.new(nodoExpresionBin, "Error de tipo: expresion binaria", tipoExpresion2)
				@errores.push(error)
			end	

		elsif nodoExpresionBin.tipo == 'Bits' then

			if tipoExpresion1 != nil && tipoExpresion1.upcase != 'BITS' then
				#ERROR DE TIPO EXPRESION
				error = ErrorSemantico.new(nodoExpresionBin, "Error de tipo: expresion binaria", tipoExpresion1)
				@errores.push(error)
			end	

			if tipoExpresion2 != nil && tipoExpresion2.upcase != 'BITS' then
				#ERROR DE TIPO EXPRESION
				error = ErrorSemantico.new(nodoExpresionBin, "Error de tipo: expresion binaria", tipoExpresion2)
				@errores.push(error)
			end	

		elsif nodoExpresionBin.tipo == "BitsInt" then

			if tipoExpresion1 != nil && tipoExpresion1.upcase != 'BITS' then
				# ERROR DE TIPO EXPRESION
				error = ErrorSemantico.new(nodoExpresionBin, "Error de tipo: expresion binaria BitsInt", [tipoExpresion1.downcase, "izquierda"]) #CAMBIAR A EXPRESION BITSINT
				@errores.push(error)
			end

			if tipoExpresion2 != nil && tipoExpresion2.upcase != 'INT' then
				# ERROR DE TIPO EXPRESION
				error = ErrorSemantico.new(nodoExpresionBin, "Error de tipo: expresion binaria BitsInt", [tipoExpresion2.downcase, "derecha"])
				@errores.push(error)
			end

		elsif nodoExpresionBin.tipo == 'Comparacion' then

			if tipoExpresion1 != nil && tipoExpresion2 != nil && tipoExpresion1.upcase != tipoExpresion2.upcase then
				#ERROR DE TIPO EXPRESION, COMPARACION
				error = ErrorSemantico.new(nodoExpresionBin, "Error de tipo: expresion binaria con operadores == o !=", nil)
				@errores.push(error)
			end
		end
	end

	def manejadorExpresionUn(nodoExpresionUn, idTabla)

		tipoExpresion = tipoExpresion(nodoExpresionUn.expresion, idTabla)

		manejadorExpresion(nodoExpresionUn.expresion, idTabla)

		if nodoExpresionUn.tipo == 'Aritmetica' then

			if tipoExpresion != nil && tipoExpresion.upcase != 'INT' then
				#ERROR DE TIPO EXPRESION
				error = ErrorSemantico.new(nodoExpresionUn, "Error de tipo: expresion unaria", tipoExpresion)
				@errores.push(error)
			end

		elsif nodoExpresionUn.tipo == 'Logica' then

			if tipoExpresion != nil && tipoExpresion.upcase != 'BOOL' then
				#ERROR DE TIPO EXPRESION
				error = ErrorSemantico.new(nodoExpresionUn, "Error de tipo: expresion unaria", tipoExpresion)
				@errores.push(error)
			end	

		elsif nodoExpresionUn.tipo == 'Bits' then
			if tipoExpresion != nil && tipoExpresion.upcase != 'BITS' then
				#ERROR DE TIPO EXPRESION
				error = ErrorSemantico.new(nodoExpresionUn, "Error de tipo: expresion unaria", tipoExpresion)
				@errores.push(error)
			end	

		end
	end

	def manejadorId(nodoId, idTabla)
		tipo = encontrarTipoTablas(nodoId.valor.str, idTabla)

		if tipo == nil then
			# ERROR, UTILIZACION SIN DECLARAR
			error = ErrorSemantico.new(nodoId, "Utilizacion de variable no declarada", nil)
			@errores.push(error)
		end
	end

	def manejadorCondicional(nodoCondicional, idTabla)
		condicion = nodoCondicional.expresion

		if condicion.is_a?(NodoExpresionBin) || condicion.is_a?(NodoExpresionUn) then
			if condicion.tipoResultado != 'BOOL' then
				# ERROR EN CONDICION, DEBE SER BOOL
				error = ErrorSemantico.new(condicion, "Error de tipo: condicion del if", nil)
				@errores.push(error)
			end

			manejadorExpresion(condicion, idTabla)

		elsif condicion.is_a?(NodoId) then
			tipo = encontrarTipoTablas(condicion.valor.str, idTabla)

			manejadorId(condicion, idTabla)

			if tipo != nil && !chequeoTipoEquivalente(tipo, 'BOOLEAN') then
				# ERROR EN CONDICION, DEBE SER BOOL
				error = ErrorSemantico.new(condicion, "Error de tipo: condicion del if", nil)
				@errores.push(error)
			end

		elsif !condicion.is_a?(NodoBool) then
			# ERROR EN CONDICION, DEBE SER BOOL
			error = ErrorSemantico.new(condicion, "Error de tipo: condicion del if", nil)
			@errores.push(error)
		end

		manejadorInstDec(nodoCondicional.instDec, idTabla)

		if nodoCondicional.clausuraElse != nil then
			manejadorInstDec(nodoCondicional.clausuraElse.instDec, idTabla)
		end
	end

	def manejadorInstDec(nodoInstDec, idTabla)
		if nodoInstDec.is_a?(NodoInstruccion) then
			manejadorInstruccion(nodoInstDec, idTabla)

		elsif nodoInstDec.is_a?(NodoDeclaracion) then
			manejadorDeclaracion(nodoInstDec, idTabla)
		end
	end

	def manejadorFor(nodoFor, idTabla)
		# REVISION DE TIPO DE VARIABLE DE ITERACION
		tipoVarIteracion = Token.new("int", -1, -1)

		manejadorExpresion(nodoFor.asignacion.expresion, idTabla)

		if nodoFor.asignacion.expresion.is_a?(NodoExpresionBin) || nodoFor.asignacion.expresion.is_a?(NodoExpresionUn) then

			if !chequeoTipoEquivalente(tipoVarIteracion, nodoFor.asignacion.expresion.tipoResultado) then
				# ERROR DE TIPO DE ASIGNACION
				error = ErrorSemantico.new(nodoFor.asignacion.expresion, "Error de tipo: inicializacion de tipo distinto", [tipoVarIteracion.str])
				@errores.push(error)
			end

		elsif nodoFor.asignacion.expresion.is_a?(NodoId) then
			tipoAsignado = encontrarTipoTablas(nodoFor.asignacion.expresion.valor.str, idTabla)
			tipoExistente = tipoVarIteracion.str

			if tipoAsignado != nil && tipoAsignado.str != tipoExistente then
				error = ErrorSemantico.new(nodoFor.asignacion.expresion, "Error de tipo: inicializacion de tipo distinto", [tipoVarIteracion.str])
				@errores.push(error)
			end	

		else
			if !chequeoTipoEquivalente(tipoVarIteracion, nodoFor.asignacion.expresion.valor.type) then
				# ERROR DE TIPO DE ASIGNACION
				error = ErrorSemantico.new(nodoFor.asignacion.expresion, "Error de tipo: inicializacion de tipo distinto", [tipoVarIteracion.str])
				@errores.push(error)
			end

		end
		
		# REVISION VALOR DE PASO
		paso = nodoFor.expresion2

		if paso.is_a?(NodoExpresionBin) || paso.is_a?(NodoExpresionUn) then
			if paso.tipoResultado != 'INT' then
				# ERROR EN VALOR DE PASO, DEBE SER INT
				error = ErrorSemantico.new(paso, "Error de tipo: valor de paso del for", nil)
				@errores.push(error)
			end

			manejadorExpresion(paso, idTabla)

		elsif paso.is_a?(NodoId) then
			tipo = encontrarTipoTablas(paso.valor.str, idTabla)

			manejadorId(paso, idTabla)

			if tipo != nil && !chequeoTipoEquivalente(tipo, 'INTEGER') then
				# ERROR EN VALOR DE PASO, DEBE SER INT
				error = ErrorSemantico.new(paso, "Error de tipo: valor de paso del for", nil)
				@errores.push(error)
			end

		elsif !paso.is_a?(NodoInt) then
			# ERROR EN VALOR DE PASO, DEBE SER INT
			error = ErrorSemantico.new(paso, "Error de tipo: valor de paso del for", nil)
			@errores.push(error)
		end

		# CREACION DE TABLA DE SIMBOLOS DEL FOR
		@contadorTablas = @contadorTablas + 1

		tabla = TablaSimbolos.new @contadorTablas

		tabla.insertar(nodoFor.asignacion.id, tipoVarIteracion, nil, nodoFor.asignacion.expresion, false)
		tablasSimbolos.push(tabla)

		idTabla = idTabla+1

		# REVISION DE CONDICION
		condicion = nodoFor.expresion1

		if condicion.is_a?(NodoExpresionBin) || condicion.is_a?(NodoExpresionUn) then
			if condicion.tipoResultado != 'BOOL' then
				# ERROR EN CONDICION, DEBE SER BOOL
				error = ErrorSemantico.new(condicion, "Error de tipo: condicion del for", nil)
				@errores.push(error)
			end

			manejadorExpresion(condicion, idTabla)

		elsif condicion.is_a?(NodoId) then
			tipo = encontrarTipoTablas(condicion.valor.str, idTabla)

			manejadorId(condicion, idTabla)

			if tipo != nil && !chequeoTipoEquivalente(tipo, 'BOOLEAN') then
				# ERROR EN CONDICION, DEBE SER BOOL
				error = ErrorSemantico.new(condicion, "Error de tipo: condicion del for", nil)
				@errores.push(error)
			end

		elsif !condicion.is_a?(NodoBool) then
			# ERROR EN CONDICION, DEBE SER BOOL
			error = ErrorSemantico.new(condicion, "Error de tipo: condicion del for", nil)
			@errores.push(error)
		end


		manejadorInstDec(nodoFor.instDec, idTabla)
		@tablasSimbolos.pop()
		@contadorTablas = @contadorTablas - 1
	end

	def manejadorForBits(nodoForBits, idTabla)
		# REVISION DE EXPRESION DE BITS
		expresionBits = nodoForBits.expresion1

		if expresionBits.is_a?(NodoExpresionBin) || expresionBits.is_a?(NodoExpresionUn) then
			if expresionBits.tipoResultado != 'BITS' then
				# ERROR EN EXPRESION BITS, DEBE SER BITS
				error = ErrorSemantico.new(expresionBits, "Error de tipo: expresion bits del forbits", nil)
				@errores.push(error)
			end

			manejadorExpresion(expresionBits, idTabla)

		elsif expresionBits.is_a?(NodoId) then
			tipo = encontrarTipoTablas(expresionBits.valor.str, idTabla)

			manejadorId(expresionBits, idTabla)

			if tipo != nil && !chequeoTipoEquivalente(tipo, 'BITARRAY') then
				# ERROR EN EXPRESION BITS, DEBE SER BITS
				error = ErrorSemantico.new(expresionBits, "Error de tipo: expresion bits del forbits", nil)
				@errores.push(error)
			end

		elsif !expresionBits.is_a?(NodoBits) then
			# ERROR EN EXPRESION BITS, DEBE SER BITS
			error = ErrorSemantico.new(expresionBits, "Error de tipo: expresion bits del forbits", nil)
			@errores.push(error)
		end

		# REVISION EXPRESION INT
		expresionInt = nodoForBits.expresion2

		if expresionInt.is_a?(NodoExpresionBin) || expresionInt.is_a?(NodoExpresionUn) then
			if expresionInt.tipoResultado != 'INT' then
				# ERROR EN EXPRESION INT, DEBE SER INT
				error = ErrorSemantico.new(expresionInt, "Error de tipo: expresion int del forbits", nil)
				@errores.push(error)
			end

			manejadorExpresion(expresionInt, idTabla)

		elsif expresionInt.is_a?(NodoId) then
			tipo = encontrarTipoTablas(expresionInt.valor.str, idTabla)

			manejadorId(expresionInt, idTabla)

			if tipo != nil && !chequeoTipoEquivalente(tipo, 'INTEGER') then
				# ERROR EN EXPRESION INT, DEBE SER INT
				error = ErrorSemantico.new(expresionInt, "Error de tipo: expresion int del forbits", nil)
				@errores.push(error)
			end

		elsif !expresionInt.is_a?(NodoInt) then
			# ERROR EN EXPRESION INT, DEBE SER INT
			error = ErrorSemantico.new(expresionInt, "Error de tipo: expresion int del forbits", nil)
			@errores.push(error)
		end

		# REVISION DE TIPO DE VARIABLE DE ITERACION
		tipoVarIteracion = Token.new("int", -1, -1)
		@contadorTablas = @contadorTablas + 1

		tabla = TablaSimbolos.new @contadorTablas

		tabla.insertar(nodoForBits.id, tipoVarIteracion, nil, nil, false)
		tablasSimbolos.push(tabla)

		idTabla = idTabla+1

		manejadorInstDec(nodoForBits.instDec, idTabla)

		@tablasSimbolos.pop()
		@contadorTablas = @contadorTablas - 1	
	end

	def manejadorWhile(nodoWhile, idTabla)
		manejadorInstDec(nodoWhile.instDec1, idTabla)

		condicion = nodoWhile.expresion

		if condicion.is_a?(NodoExpresionBin) || condicion.is_a?(NodoExpresionUn) then
			if condicion.tipoResultado != 'BOOL' then
				# ERROR EN CONDICION, DEBE SER BOOL
				error = ErrorSemantico.new(condicion, "Error de tipo: condicion del while", nil)
				@errores.push(error)
			end

			manejadorExpresion(condicion, idTabla)

		elsif condicion.is_a?(NodoId) then
			tipo = encontrarTipoTablas(condicion.valor.str, idTabla)

			manejadorId(condicion, idTabla)

			if tipo != nil && !chequeoTipoEquivalente(tipo, 'BOOLEAN') then
				# ERROR EN CONDICION, DEBE SER BOOL
				error = ErrorSemantico.new(condicion, "Error de tipo: condicion del while", nil)
				@errores.push(error)
			end

		elsif !condicion.is_a?(NodoBool) then
			# ERROR EN CONDICION, DEBE SER BOOL
			error = ErrorSemantico.new(condicion, "Error de tipo: condicion del while", nil)
			@errores.push(error)
		end

		manejadorInstDec(nodoWhile.instDec2, idTabla)
	end
	
	# tipoExpresion
	# Funcion que devuelve el tipo de una expresion
	# Parametros de entrada: nodoExpresion, idTabla
	def tipoExpresion(nodoExpresion, idTabla)
		if nodoExpresion.is_a?(NodoExpresionBin) || nodoExpresion.is_a?(NodoExpresionUn) then
			tipo = nodoExpresion.tipoResultado

		elsif nodoExpresion.is_a?(NodoId) then
			tipo = encontrarTipoTablas(nodoExpresion.valor.str, idTabla)
			if tipo != nil then
				tipo = tipo.str
			end

		elsif nodoExpresion.is_a?(NodoInt) then
			tipo = "INT"

		elsif nodoExpresion.is_a?(NodoBool) then
			tipo = "BOOL"

		elsif nodoExpresion.is_a?(NodoBits) then
			tipo = "BITS"

		elsif nodoExpresion.is_a?(NodoStr) then
			tipo = "STR"

		else
			tipo = nil
		end

		return tipo
	end

	# chequeoTipoTablas
	# Funcion que compara los tipos de dos nodos identificador
	# Parametros de entrada: tipo, identificador, idTabla
	def chequeoTipoTablas(tipo, identificador, idTabla)
		for i in (0..idTabla).reverse_each
			if tablasSimbolos[i].contiene(identificador) then
				tipoStr = tablasSimbolos[i].encontrar(identificador)[0].str
				return chequeoTipoEquivalente(tipo, tipoStr)
			end
		end

		return -1
	end

	# encontrarTipoTablas
	# Funcion que devuelve el tipo de un nodo identificador
	# Parametros de entrada: identificador, idTabla
	def encontrarTipoTablas(identificador, idTabla)
		
		for i in (0..idTabla).reverse_each
			if tablasSimbolos[i].contiene(identificador) then

				tipo = tablasSimbolos[i].encontrar(identificador)[0]
				return tipo
			end
		end

		return nil
	end

	# encontrarModificableTabla
	# Funcion que revisa si a un nodo identificador se le puede modificar su valor
	# Parametros de entrada: identificador, idTabla
	def encontrarModificableTablas(identificador, idTabla)
		
		for i in (0..idTabla).reverse_each
			if tablasSimbolos[i].contiene(identificador) then

				modificable = tablasSimbolos[i].esModificable(identificador)
				return modificable
			end
		end

		return nil
	end

	# chequeoTipoEquivalente
	# Funcion que compara los tipos de dos nodos.
	# Parametros de entrada: tipo, tipoStr
	def chequeoTipoEquivalente(tipo, tipoStr)

		if tipo.str == "INT" || tipo.str == "int" then
			if tipoStr == "INTEGER" || tipoStr == "Aritmetica" || tipoStr == "INT" then
				return true
			else
				return false
			end
		end

		if tipo.str == "BOOL" || tipo.str == "bool" then
			if tipoStr == "BOOLEAN" || tipoStr == "Logica" || tipoStr == "BOOL" then
				return true
			else
				return false
			end
		end

		if tipo.str == "BITS" || tipo.str == "bits" then
			if tipoStr == "BITARRAY" || tipoStr == "Bits" || tipoStr == "BITS" then
				return true
			else
				return false
			end
		end

		return false
	end	

end