Autores
-------------------------------------------------------------------

Lautaro Villalón. Carnet: 12-10427
Yarima Luciani. Carnet: 13-10770

Universidad Simón Bolívar
Departamento de Computación y Tecnología de la Información 
CI-3725: Traductores e Interpretadores
Etapa 1 del proyecto Bitiondo
Sept-Dic 2017 


Detalles de implementación del programa (Lexer.rb)
-------------------------------------------------------------------

- Se creó una clase Token para guardar el token, la línea, la columna y el tipo de token. 

- Dentro de dicha clase, se implementó la función tokenIdentifier, la cual posee un diccionario de expresiones regulares, que nos permite, a través de sus claves, asignarle al tipo de token el string que definirá su uso. Incluyendo los tokens que determinan los errores.

- A partir del tipo de token determinado, en la funcion toString, podemos imprimir en pantalla la información necesaria de cada token.

- Se creó una clase Lexer para realizar el análisis léxico de un archivo escrito en el lenguaje de programación Bitiondo, en la cual se guarda una lista de tokens y una lista de errores. 

- Dentro de dicha clase, se implementó la función leer, la cual lee el archivo en Bitiondo y va recolectando todos los posibles tokens, incluyendo espacios, los cuales son eliminados luego. Además, recolecta los errores léxicos mientras lee el archivo.

- Para recolectar dichos tokens, se utilizó un solo regex llamado superRegex, que capta genéricamente todas las palabras sin discriminar a las palabras reservadas. Además, detecta los comentarios, espacios en blanco y símbolos. Para posteriormente ignorar la líneas que sean comentarios y eliminar los espacios. 


Estado actual del proyecto 
-------------------------------------------------------------------

- Actualmente, el programa funciona perfectamente.

- Además, el programa permite la fácil adaptación de mejoras que optimicen los tiempos de corrida del mismo.


Problemas presentes 
-------------------------------------------------------------------

- El programa no presenta ningún problema. 


Tabla de Símbolos 
-------------------------------------------------------------------

| Símbolo				| Representación
| ----------------------------------------------------------------------------------
| Palabras Reservadas 	| begin, end, int, bool, bits, input, output, outputln, if,
| 		            	| else, for, forbits, as, from, going, higher, lower, repeat,
| 		            	| while, do
| ----------------------------------------------------------------------------------
| Objeto Booleano		| boolean, valor: true o false
| ----------------------------------------------------------------------------------
| Identificador			| identifier, valor: respectivo
| ----------------------------------------------------------------------------------
| Objeto Arreglo Bits 	| bit array, valor: respectivo
| ----------------------------------------------------------------------------------
| Objeto Entero			| integer, valor: respectivo
| ----------------------------------------------------------------------------------
| Objeto String 		| string, valor: respectivo
| ----------------------------------------------------------------------------------
| Corchetes				| left bracket o right bracket
| ----------------------------------------------------------------------------------
| Negación Bits 		| not bits
| ----------------------------------------------------------------------------------
| Dollar 				| dollar
| ----------------------------------------------------------------------------------
| Arroba 				| at
| ----------------------------------------------------------------------------------
| Menos o resta 		| minus
| ----------------------------------------------------------------------------------
| Multiplicación		| product
| ----------------------------------------------------------------------------------
| División 				| division
| ----------------------------------------------------------------------------------
| Módulo 				| module
| ----------------------------------------------------------------------------------
| Suma 				    | plus
| ----------------------------------------------------------------------------------
| Desplazamiento izq    | left displacement 
| ----------------------------------------------------------------------------------
| Desplazamiento der 	| right displacement 
| ----------------------------------------------------------------------------------
| Menor o igual que 	| less or equal than
| ----------------------------------------------------------------------------------
| Mayor o igual que 	| more or equal than
| ----------------------------------------------------------------------------------
| Menor que 	        | less than
| ----------------------------------------------------------------------------------
| Mayor que         	| more than
| ----------------------------------------------------------------------------------
| Equivalente       	| equals
| ----------------------------------------------------------------------------------
| Distinto          	| not equal
| ----------------------------------------------------------------------------------
| Negación lógica       | not
| ----------------------------------------------------------------------------------
| Asignación        	| assign
| ----------------------------------------------------------------------------------
| "Y" lógico          	| and
| ----------------------------------------------------------------------------------
| "O" lógico          	| or
| ----------------------------------------------------------------------------------
| "Y" bits          	| and bits
| ----------------------------------------------------------------------------------
| "O" exclusivo bits    | xor bits
| ----------------------------------------------------------------------------------
| "O" bits          	| or bits
| ----------------------------------------------------------------------------------
| Punto y coma          | semicolon
| ----------------------------------------------------------------------------------
| Coma          	    | comma
| ----------------------------------------------------------------------------------
| Paréntesis que abre  	| left parenthesis 
| ----------------------------------------------------------------------------------
| Paréntesis que cierra | right parenthesis 
