
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
		| declaraciones 																	{result = NodoBloquePrincipal.new(val[0], nil)}
		;

		declaraciones
		: declaracion declaraciones 														{result = NodoDeclaraciones.new(val[0], val[1])}	
		| declaracion 																		{result = NodoDeclaraciones.new(val[0], nil)}	
		;

		declaracion
		: 'INT' identificador init 'SEMICOLON'											{result = NodoDeclaracion.new(val[0], val[1], nil, val[2])}	
		| 'BOOL' identificador init 'SEMICOLON'											{result = NodoDeclaracion.new(val[0], val[1], nil, val[2])}	
		| 'BITS' identificador 'LEFTBRACKET' expresionP 'RIGHTBRACKET' init 'SEMICOLON'	{result = NodoDeclaracion.new(val[0], val[1], val[3], val[5])}	
		;

		init
		: 'ASSIGN' expresionP																{result = NodoInit.new(val[1])}	
		| 																					{result = nil}	
		;

		instrucciones
		: instruccion instrucciones 														{result = NodoInstrucciones.new(val[0], val[1])}	
		| instruccion 																		{result = NodoInstrucciones.new(val[0], nil)}	
		;

		instruccion
		: S 																				{result = NodoInstruccion.new(val[0])}	
		| asignacion 'SEMICOLON'															{result = NodoInstruccion.new(val[0])}	
		| entrada 'SEMICOLON'																{result = NodoInstruccion.new(val[0])}	
		| salida 'SEMICOLON'																{result = NodoInstruccion.new(val[0])}	
		| condicional 																		{result = NodoInstruccion.new(val[0])}	
		| iteracionFor 																		{result = NodoInstruccion.new(val[0])}	
		| iteracionForBits 																	{result = NodoInstruccion.new(val[0])}	
		| iteracionWhile 																	{result = NodoInstruccion.new(val[0])}									
		; 

		expresionP
		: 'LEFTPARENTHESIS' expresion 'RIGHTPARENTHESIS'									{result = val[1]}
		| expresion 																		{result = val[0]}
		;

		expresion																		
		: expresionP 'PLUS' expresionP  													{result = NodoExpresionBin.new(val[0], NodoOperador.new(val[1]), val[2], 'Aritmetica', 'INT')}
		| expresionP 'MINUS' expresionP														{result = NodoExpresionBin.new(val[0], NodoOperador.new(val[1]), val[2], 'Aritmetica', 'INT')}	
		| expresionP 'PRODUCT' expresionP 													{result = NodoExpresionBin.new(val[0], NodoOperador.new(val[1]), val[2], 'Aritmetica', 'INT')}
		| expresionP 'DIVISION' expresionP 													{result = NodoExpresionBin.new(val[0], NodoOperador.new(val[1]), val[2], 'Aritmetica', 'INT')}
		| expresionP 'MODULE' expresionP 													{result = NodoExpresionBin.new(val[0], NodoOperador.new(val[1]), val[2], 'Aritmetica', 'INT')}
		| expresionP 'LESSTHAN' expresionP 													{result = NodoExpresionBin.new(val[0], NodoOperador.new(val[1]), val[2], 'Aritmetica', 'BOOL')}
		| expresionP 'MORETHAN' expresionP 													{result = NodoExpresionBin.new(val[0], NodoOperador.new(val[1]), val[2], 'Aritmetica', 'BOOL')}
		| expresionP 'LESSOREQUALTHAN' expresionP 											{result = NodoExpresionBin.new(val[0], NodoOperador.new(val[1]), val[2], 'Aritmetica', 'BOOL')}
		| expresionP 'MOREOREQUALTHAN' expresionP 											{result = NodoExpresionBin.new(val[0], NodoOperador.new(val[1]), val[2], 'Aritmetica', 'BOOL')}
		| expresionP 'EQUALS' expresionP 													{result = NodoExpresionBin.new(val[0], NodoOperador.new(val[1]), val[2], 'Comparacion', 'BOOL')}
		| expresionP 'NOTEQUAL' expresionP 													{result = NodoExpresionBin.new(val[0], NodoOperador.new(val[1]), val[2], 'Comparacion', 'BOOL')}
		| expresionP 'AND' expresionP 														{result = NodoExpresionBin.new(val[0], NodoOperador.new(val[1]), val[2], 'Logica', 'BOOL')}
		| expresionP 'OR' expresionP  														{result = NodoExpresionBin.new(val[0], NodoOperador.new(val[1]), val[2], 'Logica', 'BOOL')}
		| expresionP 'ANDBITS' expresionP 													{result = NodoExpresionBin.new(val[0], NodoOperador.new(val[1]), val[2], 'Bits', 'BITS')}
		| expresionP 'ORBITS' expresionP 													{result = NodoExpresionBin.new(val[0], NodoOperador.new(val[1]), val[2], 'Bits', 'BITS')}
		| expresionP 'XORBITS' expresionP 													{result = NodoExpresionBin.new(val[0], NodoOperador.new(val[1]), val[2], 'Bits', 'BITS')}
		| expresionP 'RIGHTDISPLACEMENT' expresionP 										{result = NodoExpresionBin.new(val[0], NodoOperador.new(val[1]), val[2], 'BitsInt', 'BITS')}
		| expresionP 'LEFTDISPLACEMENT' expresionP 											{result = NodoExpresionBin.new(val[0], NodoOperador.new(val[1]), val[2], 'BitsInt', 'BITS')}	
		| 'MINUS' expresionP ='UMINUS'														{result = NodoExpresionUn.new(NodoOperador.new(val[0]), val[1], nil, 'Aritmetica', 'INT')}						
		| 'AT' expresionP																	{result = NodoExpresionUn.new(NodoOperador.new(val[0]), val[1], nil, 'Aritmetica', 'BITS')}
		| 'NOT' expresionP																	{result = NodoExpresionUn.new(NodoOperador.new(val[0]), val[1], nil, 'Logica', 'BOOL')}
		| 'NOTBITS' expresionP																{result = NodoExpresionUn.new(NodoOperador.new(val[0]), val[1], nil, 'Bits', 'BITS')}
		| 'DOLLAR' expresionP 																{result = NodoExpresionUn.new(NodoOperador.new(val[0]), val[1], nil, 'Bits', 'INT')}
		| identificador 
		| entero
		| booleano 
		| arregloBits
		| cadena
		| expresionP 'LEFTBRACKET' expresionP 'RIGHTBRACKET'        						{result = NodoExpresionBin.new(val[0], NodoOperador.new('ACCESS'), val[2], 'BitsInt', 'INT')}
		;

		asignacion
		: identificador 'ASSIGN' expresionP 												{result = NodoAsignacion.new(val[0], val[2], nil)}
		| identificador 'LEFTBRACKET' expresionP 'RIGHTBRACKET' 'ASSIGN' expresionP 		{result = NodoAsignacion.new(val[0], val[5], val[2])}
		;

		entrada
		: 'INPUT' identificador																{result = NodoEntrada.new(val[1])}
		;

		salida 
		: 'OUTPUT' expMultiple 																{result = NodoSalida.new(val[0], val[1])}
		| 'OUTPUTLN' expMultiple 															{result = NodoSalida.new(val[0], val[1])}
		;

		expMultiple
		: expresionP 'COMMA' expMultiple 													{result = NodoExpMultiple.new(val[0], val[2])}
		| expresionP 																		{result = NodoExpMultiple.new(val[0], nil)}
		;

		condicional 
		: 'IF' 'LEFTPARENTHESIS' expresionP 'RIGHTPARENTHESIS' instruccionDeclaracion clausuraElse 		{result = NodoCondicional.new(val[2], val[4], val[5])} 
		;

		clausuraElse 
		: 'ELSE' instruccionDeclaracion														{result = NodoClausuraElse.new(val[1])}
		|																					{result = nil}
		; 

		iteracionFor 
		: 'FOR' 'LEFTPARENTHESIS' asignacion 'SEMICOLON' expresionP 'SEMICOLON' expresionP 'RIGHTPARENTHESIS' instruccionDeclaracion				{result = NodoFor.new(val[2], val[4], val[6], val[8])}
		;

		iteracionForBits
		: 'FORBITS' expresionP 'AS' identificador 'FROM' expresionP 'GOING' 'HIGHER' instruccionDeclaracion 										{result = NodoForBits.new(val[1], val[3], val[5], val[7], val[8])}
		| 'FORBITS' expresionP 'AS' identificador 'FROM' expresionP 'GOING' 'LOWER' instruccionDeclaracion 										{result = NodoForBits.new(val[1], val[3], val[5], val[7], val[8])}
		;

		iteracionWhile 
		: 'REPEAT' instruccionDeclaracion 'WHILE' 'LEFTPARENTHESIS' expresionP 'RIGHTPARENTHESIS' 'DO' instruccionDeclaracion 					{result = NodoWhile.new(val[0], val[1], val[4], val[6], val[7])}
		| 'WHILE' 'LEFTPARENTHESIS' expresionP 'RIGHTPARENTHESIS' 'DO' instruccionDeclaracion 													{result = NodoWhile.new(nil, nil, val[2], val[4], val[5])}
		| 'REPEAT' instruccionDeclaracion 'WHILE' 'LEFTPARENTHESIS' expresionP 'RIGHTPARENTHESIS' 'SEMICOLON'									{result = NodoWhile.new(val[0], val[1], val[4], nil, nil)}
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

