
# Parser.y

# Descripcion: Parser del lenguaje de programacion Bitiondo 

# Autores:
	# Lautaro Villalon. 12-10427
	# Yarima Luciani. 13-10770



class Parser

	# Precedencia de los operadores 

	prechigh 

	right 'RIGHTBRACKET'
	left 'LEFTBRACKET'
	right 'NOT' 'NOTBITS' 'DOLLAR' 'AT' 'UMINUS' 
	left 'PRODUCT' 'DIVISION' 'MODULE' 
	left 'PLUS' 'MINUS'
	left 'LEFTDISPLACEMENT' 'RIGHTDISPLACEMENT'
	nonassoc 'LESSTHAN' 'LESSOREQUALTHAN' 'MORETHAN' 'MOREOREQUALTHAN'
	left 'EQUALS' 'NOTEQUAL'
	left 'ANDBITS'
	left 'XORBITS'
	left 'ORBITS'
	left 'AND'
	left 'OR' 

	preclow 	

	# Lista de tokens 

	token	'BEGIN' 'END' 'INT' 'BOOL' 'BITS' 'INPUT' 'OUTPUT' 'OUTPUTLN' 'IF' 'ELSE' 'FOR' 'FORBITS' 'AS' 'FROM'
			'GOING' 'HIGHER' 'LOWER' 'REPEAT' 'WHILE' 'DO' 'TRUE' 'FALSE' 'BOOLEAN' 'IDENTIFIER' 'BITARRAY'
			'INTEGER' 'STRING' 'LEFTBRACKET' 'RIGHTBRACKET' 'NOTBITS' 'DOLLAR' 'AT' 'MINUS' 'PRODUCT' 
			'DIVISION' 'MODULE' 'PLUS' 'LEFTDISPLACEMENT' 'RIGHTDISPLACEMENT' 'LESSOREQUALTHAN' 
			'MOREOREQUALTHAN' 'LESSTHAN' 'MORETHAN' 'EQUALS' 'NOTEQUAL' 'NOT' 'ASSIGN' 'AND' 'OR' 'ANDBITS'
			'XORBITS' 'ORBITS' 'SEMICOLON' 'COMMA' 'LEFTPARENTHESIS' 'RIGHTPARENTHESIS'


	# Reglas para la gramatica libre de contexto y gramatica de atributos para cada una de ellas
	
	rule

		# Regla inicial
		S 
		: 'BEGIN' bloquePrincipal 'END' 													{result = NodoInicial.new(val[1])}	
		| 'BEGIN' 'END'																		{result = NodoInicial.new(nil)}
		;

		bloquePrincipal
		: declaraciones instrucciones 														{result = NodoBloquePrincipal.new(val[0], val[1])}	
		| instrucciones 																	{result = NodoBloquePrincipal.new(nil, val[0])}	
		;

		declaraciones
		: declaracion declaraciones 														{result = NodoDeclaraciones.new(val[0], val[1])}	
		| declaracion 																		{result = NodoDeclaraciones.new(val[0], nil)}	
		;

		declaracion
		: 'INT' identificador initInt 'SEMICOLON'											{result = NodoDeclaracion.new(val[0], val[1], nil, val[2])}	
		| 'BOOL' identificador initBool 'SEMICOLON'											{result = NodoDeclaracion.new(val[0], val[1], nil, val[2])}	
		| 'BITS' identificador 'LEFTBRACKET' entero 'RIGHTBRACKET' initBits 'SEMICOLON'		{result = NodoDeclaracion.new(val[0], val[1], val[3], val[5])}	
		;

		initInt
		: 'ASSIGN' entero																	{result = NodoInit.new(val[1])}	
		| 																					{result = nil}	
		;

		initBool 
		: 'ASSIGN' booleano 																{result = NodoInit.new(val[1])}	
		|																					{result = nil}	
		;

		initBits 
		: 'ASSIGN' arregloBits 																{result = NodoInit.new(val[1])}	
		|																					{result = nil}	
		;

		instrucciones
		: instruccion instrucciones 														{result = NodoInstrucciones.new(val[0], val[1])}	
		| instruccion 																		{result = NodoInstrucciones.new(val[0], nil)}	
		;

		instruccion
		: S 																				{result = NodoInstruccion.new(val[0])}	
		#| expresion 'SEMICOLON'																{result = NodoInstruccion.new(val[0])}	
		| asignacion 'SEMICOLON'															{result = NodoInstruccion.new(val[0])}	
		| entrada 'SEMICOLON'																{result = NodoInstruccion.new(val[0])}	
		| salida 'SEMICOLON'																{result = NodoInstruccion.new(val[0])}	
		| condicional 																		{result = NodoInstruccion.new(val[0])}	
		| iteracionFor 																		{result = NodoInstruccion.new(val[0])}	
		| iteracionForBits 																	{result = NodoInstruccion.new(val[0])}	
		| iteracionWhile 																	{result = NodoInstruccion.new(val[0])}									
		; 

		expresion																		
		: expresion 'PLUS' expresion  														{result = NodoExpresionBin.new(val[0], NodoOperador.new(val[1]), val[2])}
		| expresion 'MINUS' expresion														{result = NodoExpresionBin.new(val[0], NodoOperador.new(val[1]), val[2])}	
		| expresion 'PRODUCT' expresion 													{result = NodoExpresionBin.new(val[0], NodoOperador.new(val[1]), val[2])}
		| expresion 'DIVISION' expresion 													{result = NodoExpresionBin.new(val[0], NodoOperador.new(val[1]), val[2])}
		| expresion 'MODULE' expresion 														{result = NodoExpresionBin.new(val[0], NodoOperador.new(val[1]), val[2])}
		| expresion 'LESSTHAN' expresion 													{result = NodoExpresionBin.new(val[0], NodoOperador.new(val[1]), val[2])}
		| expresion 'MORETHAN' expresion 													{result = NodoExpresionBin.new(val[0], NodoOperador.new(val[1]), val[2])}
		| expresion 'LESSOREQUALTHAN' expresion 											{result = NodoExpresionBin.new(val[0], NodoOperador.new(val[1]), val[2])}
		| expresion 'MOREOREQUALTHAN' expresion 											{result = NodoExpresionBin.new(val[0], NodoOperador.new(val[1]), val[2])}
		| expresion 'EQUALS' expresion 														{result = NodoExpresionBin.new(val[0], NodoOperador.new(val[1]), val[2])}
		| expresion 'NOTEQUAL' expresion 													{result = NodoExpresionBin.new(val[0], NodoOperador.new(val[1]), val[2])}
		| expresion 'AND' expresion 														{result = NodoExpresionBin.new(val[0], NodoOperador.new(val[1]), val[2])}
		| expresion 'OR' expresion  														{result = NodoExpresionBin.new(val[0], NodoOperador.new(val[1]), val[2])}
		| expresion 'ANDBITS' expresion 													{result = NodoExpresionBin.new(val[0], NodoOperador.new(val[1]), val[2])}
		| expresion 'ORBITS' expresion 														{result = NodoExpresionBin.new(val[0], NodoOperador.new(val[1]), val[2])}
		| expresion 'XORBITS' expresion 													{result = NodoExpresionBin.new(val[0], NodoOperador.new(val[1]), val[2])}
		| expresion 'RIGHTDISPLACEMENT' expresion 											{result = NodoExpresionBin.new(val[0], NodoOperador.new(val[1]), val[2])}
		| expresion 'LEFTDISPLACEMENT' expresion 											{result = NodoExpresionBin.new(val[0], NodoOperador.new(val[1]), val[2])}	
		| 'MINUS' expresion ='UMINUS'														{result = NodoExpresionUn.new(NodoOperador.new(val[0]), val[1], nil)}						
		| 'AT' expresion																	{result = NodoExpresionUn.new(NodoOperador.new(val[0]), val[1], nil)}
		| 'NOT' expresion																	{result = NodoExpresionUn.new(NodoOperador.new(val[0]), val[1], nil)}
		| 'NOTBITS' expresion																{result = NodoExpresionUn.new(NodoOperador.new(val[0]), val[1], nil)}
		| 'DOLLAR' expresion 																{result = NodoExpresionUn.new(NodoOperador.new(val[0]), val[1], nil)}
		| identificador 
		| entero
		| booleano 
		| arregloBits
		| cadena
		| identificador 'LEFTBRACKET' expresion 'RIGHTBRACKET'        						{result = NodoExpresionUn.new(NodoOperador.new('ACCESS'), val[0], val[2])}
		;

		asignacion
		: identificador 'ASSIGN' expresion 													{result = NodoAsignacion.new(val[0], val[2])}
		;

		entrada
		: 'INPUT' identificador																{result = NodoEntrada.new(val[1])}
		;

		salida 
		: 'OUTPUT' expMultiple 																{result = NodoSalida.new(val[0], val[1])}
		| 'OUTPUTLN' expMultiple 															{result = NodoSalida.new(val[0], val[1])}
		;

		expMultiple
		: expresion 'COMMA' expMultiple 													{result = NodoExpMultiple.new(val[0], val[2])}
		| expresion 																		{result = NodoExpMultiple.new(val[0], nil)}
		;

		condicional 
		: 'IF' 'LEFTPARENTHESIS' expresion 'RIGHTPARENTHESIS' instruccionDeclaracion clausuraElse 		{result = NodoFor.new(val[2], val[4], val[5])} 
		;

		clausuraElse 
		: 'ELSE' instruccionDeclaracion														{result = NodoClausuraElse.new(val[1])}
		|																					{result = nil}
		; 

		iteracionFor 
		: 'FOR' 'LEFTPARENTHESIS' asignacion 'SEMICOLON' expresion 'SEMICOLON' expresion 'RIGHTPARENTHESIS' instruccionDeclaracion				{result = NodoFor.new(val[2], val[4], val[6], val[8])}
		;

		iteracionForBits
		: 'FORBITS' expresion 'AS' identificador 'FROM' expresion 'GOING' 'HIGHER' instruccionDeclaracion 										{result = NodoForBits.new(val[1], val[3], val[5], val[7], val[8])}
		| 'FORBITS' expresion 'AS' identificador 'FROM' expresion 'GOING' 'LOWER' instruccionDeclaracion 										{result = NodoForBits.new(val[1], val[3], val[5], val[7], val[8])}
		;

		iteracionWhile 
		: 'REPEAT' instruccionDeclaracion 'WHILE' 'LEFTPARENTHESIS' expresion 'RIGHTPARENTHESIS' 'DO' instruccionDeclaracion 					{result = NodoWhile.new(val[0], val[1], val[4], val[6], val[7])}
		| 'WHILE' 'LEFTPARENTHESIS' expresion 'RIGHTPARENTHESIS' 'DO' instruccionDeclaracion 													{result = NodoWhile.new(nil, nil, val[2], val[4], val[5])}
		| 'REPEAT' instruccionDeclaracion 'WHILE' 'LEFTPARENTHESIS' expresion 'RIGHTPARENTHESIS' 												{result = NodoWhile.new(val[0], val[1], val[4], nil, nil)}
		; 

		instruccionDeclaracion 	
		: instruccion 																		{result = val[0]}
		| declaracion 																		{result = val[0]}																		
		;

		identificador
		: 'IDENTIFIER'																		{result = NodoId.new(val[0])}
		;

		entero
		: 'INTEGER'																			{result = NodoInt.new(val[0])}
		;

		booleano 
		: 'BOOLEAN' 																		{result = NodoBool.new(val[0])}
		;

		arregloBits
		: 'BITARRAY'																		{result = NodoBits.new(val[0])}
		;

		cadena 
		: 'STRING'																			{result = NodoStr.new(val[0])}
		;
		
end 


---- header ----

require_relative "Lexer.rb"
require_relative "astParser.rb"

class SyntacticError < RuntimeError

    def initialize(token)
        @token = token
    end

    def to_s
        puts "SYNTACTIC ERROR FOUND:"
        if @token.eql? "$" then
            puts "Unexpected EOF"
        else
            puts "ERROR: unexpected token '#{@token.str}' at line #{@token.line}, column #{@token.column}"   
        end    
    end
end


---- inner ----

def initialize(lexer)
    @lexer = lexer
end

def on_error(id, token, stack)
	SyntacticError.new(token).to_s
	exit
    #raise SyntacticError::new(token)
end

def next_token
    if @lexer.haySiguiente then
        token = @lexer.tokenSiguiente;
        return [token.type, token]
    else
        return nil
    end
end

def parse
    do_parse
end


---- footer ----

