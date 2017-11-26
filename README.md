Autores
-------------------------------------------------------------------

Lautaro Villalón. Carnet: 12-10427
Yarima Luciani. Carnet: 13-10770

Universidad Simón Bolívar
Departamento de Computación y Tecnología de la Información 
CI-3725: Traductores e Interpretadores
Proyecto Bitiondo
Sept-Dic 2017 


Detalles de implementación del programa (Lexer.rb)
-------------------------------------------------------------------

- Se creó una clase Token para guardar el token, la línea, la columna y el tipo de token. 

- Dentro de dicha clase, se implementó la función tokenIdentifier, la cual posee un diccionario de expresiones regulares, que nos permite, a través de sus claves, asignarle al tipo de token el string que definirá su uso. Incluyendo los tokens que determinan los errores.

- A partir del tipo de token determinado, en la funcion toString, podemos imprimir en pantalla la información necesaria de cada token.

- Se creó una clase Lexer para realizar el análisis léxico de un archivo escrito en el lenguaje de programación Bitiondo, en la cual se guarda una lista de tokens y una lista de errores. 

- Dentro de dicha clase, se implementó la función leer, la cual lee el archivo en Bitiondo y va recolectando todos los posibles tokens, incluyendo espacios, los cuales son eliminados luego. Además, recolecta los errores léxicos mientras lee el archivo.

- Para recolectar dichos tokens, se utilizó un solo regex llamado superRegex, que capta genéricamente todas las palabras sin discriminar a las palabras reservadas. Además, detecta los comentarios, espacios en blanco y símbolos. Para posteriormente ignorar la líneas que sean comentarios y eliminar los espacios. 



Detalles de implementación del programa (Parser.y)
-------------------------------------------------------------------

- Se definió la precedencia de los operadores del lenguaje, de mayor a menor.

- Se escribió la lista de tokens reconocidos por el Lexer.

- Se escribió la gramática libre de contexto, definiendo todas las reglas para generar el lenguaje.

- Se hizo la gramática de atributos para cada una de las reglas. 

- Se utilizó la herramienta de Ruby racc para generar el Parser.rb a través del archivo Parser.y.



Detalles de implementación del programa (astParser.rb)
-------------------------------------------------------------------

- Se creó una clase para imprimir cada nodo, la cual posee dos métodos, uno para inicializar el nodo y el otro para imprimirlo. 

- Se creó una clase Nodo General que define el espaciado para imprimir un nodo. 

- Todas las clases heredan las propiedades de la clase Nodo General.

- Hay una clase por la mayoría de las reglas de la grámatica del lenguaje, exceptuando algunas que son imprimidas por un mismo nodo, como es el caso de las instrucciones output y outputln. 



Detalles de implementación del programa (symbolTable.rb)
-------------------------------------------------------------------

- Se creó una clase TablaSimbolos, la cual posee los procedimientos requeridos en la especificación del proyecto y otros adicionales

- Los métodos adicionales son: 
	- esModificable: verifica si la variable declarada puede ser modificada (usada para verificar que no se modifiquen las variables de iteración).
	- printNivel: imprime la identación del ast.
	- printTabla: imprime una tabla de símbolos con las declaraciones.



Detalles de implementación del programa (semanticAnalyzer.rb)
-------------------------------------------------------------------

- Se realizó un manejador para recopilar los errores semánticos que pueda tener cada nodo del ast.

- Se implementaron otros métodos adicionales:
	- tipoExpresion: devuelve el tipo de una expresion.
	- chequeoTipoTablas: compara los tipos de dos nodos identificador.
	- encontrarTipoTablas: devuelve el tipo de un nodo identificador.
	- encontrarModificableTablas: revisa si un nodo identificador es modificable, es decir, si se le puede modificar su valor.
	- chequeoTipoEquivalente: compara los tipos de dos nodos.



Detalles de implementación del programa (semanticErrors.rb)
-------------------------------------------------------------------

- Define los errores semánticos que se pueden presentar.



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



