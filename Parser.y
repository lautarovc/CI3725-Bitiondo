=begin

Lexer.rb

Descripcion: Parser del lenguaje de programacion Bitiondo 

Autores:
	Lautaro Villalon. 12-10427
	Yarima Luciani. 13-10770

=end


class Parser

	# Precedencia de los operadores 

	prechigh 

	right 'NOT'
	right 'NOTBITS'
	right 'DOLLAR'
	right 'AT'
	right 'UMINUS' 

	left 'PRODUCT'
	left 'DIVISION'
	left 'MODULE' 
	left 'PLUS'
	left 'MINUS'
	left 'LEFTDISPLACEMENT'
	left 'RIGHTDISPLACEMENT'
	nonassoc 'LESSTHAN'
	nonassoc 'LESSOREQUALTHAN'
	nonassoc 'MORETHAN'
	nonassoc 'MOREOREQUALTHAN'
	left 'EQUALS'
	left 'NOTEQUAL'
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


	# Gramatica libre de contexto 
	
	rule

		# Regla inicial
		S 
		: 'BEGIN' bloquePrincipal 'END' 													{result = nodoInicial.new(val[1])}	
		;

		bloquePrincipal
		: declaraciones instrucciones 														{result = nodoBloquePrincipal.new(val[0], val[1])}	
		| instrucciones 																	{result = nodoBloquePrincipal.new(nil, val[0])}	
		;

		bloques
		: 'BEGIN' bloquePrincipal 'END' 													{result = nodoBloques.new(val[1])}	
		;

		declaraciones
		: declaracion declaraciones 														{result = nodoDeclaraciones.new(val[0], val[1])}	
		| declaracion 																		{result = nodoDeclaraciones.new(val[0], nil)}	
		| 																					{result = nil}
		;

		declaracion
		: 'INT' identificador initInt 'SEMICOLON'											{result = nodoDeclaracion,new(val[0], val[1], nil, val[2])}	
		| 'BOOL' identificador initBool 'SEMICOLON'											{result = nodoDeclaracion.new(val[0], val[1], nil, val[2])}	
		| 'BITS' identificador 'LEFTBRACKET' entero 'RIGHTBRACKET' initBits 'SEMICOLON'		{result = nodoDeclaracion.new(val[0], val[1], val[3], val[5])}	
		;

		initInt
		: 'ASSIGN' entero																	{result = nodoInit.new(val[1])}	
		| 																					{result = nil}	
		;

		initBool 
		: 'ASSIGN' booleano 																{result = nodoInit.new(val[1])}	
		|																					{result = nil}	
		;

		initBits 
		: 'ASSIGN' arregloBits 																{result = nodoInit.new(val[1])}	
		|																					{result = nil}	
		;

		instrucciones
		: instruccion instrucciones 														{result = nodoInstrucciones.new(val[0], val[1])}	
		| instruccion 																		{result = nodoInstrucciones.new(val[0], nil)}	
		;

		instruccion
		: bloque 																			{result = nodoInstruccion.new(val[0])}	
		| expresion 'SEMICOLON'																{result = nodoInstruccion.new(val[0])}	
		| asignacion 'SEMICOLON'															{result = nodoInstruccion.new(val[0])}	
		| entrada 'SEMICOLON'																{result = nodoInstruccion.new(val[0])}	
		| salida 'SEMICOLON'																{result = nodoInstruccion.new(val[0])}	
		| condicional 'SEMICOLON'															{result = nodoInstruccion.new(val[0])}	
		| iteracionFor 'SEMICOLON'															{result = nodoInstruccion.new(val[0])}	
		| iteracionForBits 'SEMICOLON'														{result = nodoInstruccion.new(val[0])}	
		| iteracionWhile 'SEMICOLON'														{result = nodoInstruccion.new(val[0])}	
		| 																					{result = nil}	
		; 

		expresion
		: expresion operadorBinario expresion 												{result = nodoExpresionBin.new(val[0], val[1], val[2])}	
		| operadorUnario expresion 															{result = nodoExpresionUn.new(val[0], val[1])}	
		| identificador 
		| entero
		| booleano 
		| arregloBits
		| cadena
		| identificador 'LEFTBRACKET' entero 'RIGHTBRACKET'        	# no se que soy
		;

		operadorBinario
		: 'PLUS'  																			{result = nodoOperador.new(val[0])}
		| 'MINUS'																			{result = nodoOperador.new(val[0])}
		| 'PRODUCT' 																		{result = nodoOperador.new(val[0])}
		| 'DIVISION' 																		{result = nodoOperador.new(val[0])}
		| 'MODULE' 																			{result = nodoOperador.new(val[0])}
		| 'LESSTHAN' 																		{result = nodoOperador.new(val[0])}
		| 'MORETHAN' 																		{result = nodoOperador.new(val[0])}
		| 'LESSOREQUALTHAN' 																{result = nodoOperador.new(val[0])}
		| 'MOREOREQUALTHAN' 																{result = nodoOperador.new(val[0])}
		| 'EQUALS' 																			{result = nodoOperador.new(val[0])}
		| 'NOTEQUAL' 																		{result = nodoOperador.new(val[0])}
		| 'AND' 																			{result = nodoOperador.new(val[0])}
		| 'OR'  																			{result = nodoOperador.new(val[0])}
		| 'ANDBITS' 																		{result = nodoOperador.new(val[0])}
		| 'ORBITS' 																			{result = nodoOperador.new(val[0])}
		| 'XORBITS' 																		{result = nodoOperador.new(val[0])}
		| 'RIGHTDISPLACEMENT' 																{result = nodoOperador.new(val[0])}
		| 'LEFTDISPLACEMENT' 																{result = nodoOperador.new(val[0])}
		;

		operadorUnario 
		: 'MINUS' ='UMINUS'																	{result = nodoOperador.new(val[0])}
		| 'AT' 																				{result = nodoOperador.new(val[0])}
		| 'NOT'  																			{result = nodoOperador.new(val[0])}
		| 'NOTBITS' 																		{result = nodoOperador.new(val[0])}
		| 'DOLLAR'   																		{result = nodoOperador.new(val[0])}
		;

		asignacion
		: identificador 'ASSIGN' expresion 													{result = nodoAsignacion.new(val[0], val[2])}
		;

		entrada
		: 'INPUT' identificador																{result = nodoEntrada.new(val[1])}
		;

		salida 
		: 'OUTPUT' expMultiple 																{result = nodoSalida.new(val[0], val[1])}
		| 'OUTPUTLN' expMultiple 															{result = nodoSalida.new(val[0], val[1])}
		;

		expMultiple
		: expresion 'COMMA' expMultiple 													{result = nodoExpMultiple.new(val[0], val[2])}
		| expresion 																		{result = nodoExpMultiple.new(val[0], nil)}
		;

		condicional 
		: 'IF' 'LEFTPARENTHESIS' expresion 'RIGHTPARENTHESIS' instruccionDeclaracion clausuraElse {result = nodoFor.new(val[2], val[4], val[5])} 
		;

		clausuraElse 
		: 'ELSE' instruccionDeclaracion														{result = nodoClausuraElse.new(val[1])}
		|																					{result = nil}
		; 

		iteracionFor 
		: 'FOR' 'LEFTPARENTHESIS' asignacion 'SEMICOLON' expresion 'SEMICOLON' expresion 'RIGHTPARENTHESIS' instruccionDeclaracion				{result = nodoFor.new(val[2], val[4], val[6], val[8])}
		;

		iteracionForBits
		: 'FORBITS' expresion 'AS' identificador 'FROM' expresion 'GOING' 'LEFTPARENTHESIS' 'HIGHER' 'RIGHTPARENTHESIS' instruccionDeclaracion 	{result = nodoForBits.new(val[1], val[3], val[5], val[8], val[10])}
		| 'FORBITS' expresion 'AS' identificador 'FROM' expresion 'GOING' 'LEFTPARENTHESIS' 'LOWER' 'RIGHTPARENTHESIS' instruccionDeclaracion 	{result = nodoForBits.new(val[1], val[3], val[5], val[8], val[10])}
		;

		iteracionWhile 
		: 'REPEAT' instruccionDeclaracion 'WHILE' 'LEFTPARENTHESIS' expresion 'RIGHTPARENTHESIS' 'DO' instruccionDeclaracion 					{result = nodoWhile.new(val[0], val[1], val[4], val[6], val[7])}
		| 'WHILE' 'LEFTPARENTHESIS' expresion 'RIGHTPARENTHESIS' 'DO' instruccionDeclaracion 													{result = nodoWhile.new(nil, nil, val[2], val[4], val[5])}
		| 'REPEAT' instruccionDeclaracion 'WHILE' 'LEFTPARENTHESIS' expresion 'RIGHTPARENTHESIS' 												{result = nodoWhile.new(val[0], val[1], val[4], nil, nil)}
		; 

		instruccionDeclaracion 	
		: instruccion 																		{result = val[0]}
		| declaracion 																		{result = val[0]}
		;

		identificador
		: 'IDENTIFIER'																		{result = nodoId.new(val[0])}
		;

		entero
		: 'INTEGER'																			{result = nodoInt.new(val[0])}
		;

		booleano 
		: 'BOOLEAN' 																		{result = nodoBool.new(val[0])}
		;

		arregloBits
		: 'BITARRAY'																		{result = nodoBits.new(val[0])}
		;

		cadena 
		: 'STRING'																			{result = nodoStr.new(val[0])}
		;
		
	end 


---- header 

require_relative "Lexer.rb"
require_relative "astParser.rb"

class SyntacticError < RuntimeError

    def initialize(token)
        @token = token
    end

    def to_s
        puts "SYNTACTIC ERROR FOUND:"
        if @token.eql? "$" then
            "Unexpected EOF"
        else
            "Line #{@token.line}, column #{@token.column}: unexpected token #{@token.symbol}: #{@token.value}"   
        end
    end
end


---- inner

def initialize(lexer)
    @lexer = lexer
end

def on_error(id, token, stack)
    raise SyntacticError::new(token)
end

def next_token
    if @lexer.has_next_token then
        token = @lexer.next_token;
        return [token.symbol,token]
    else
        return nil
    end
end

def parse
    do_parse
end


---- footer

