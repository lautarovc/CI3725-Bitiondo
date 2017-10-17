


class Token

	def initialize(str, line, column)
		@str = str
		@line = line
		@column = column
		@tipo = tokenIdentifier()
	end

	def tokenIdentifier()


	end

end


class Lexer

	def initialize(file) 
		@file = file
		@tokens = []
		@errorList = []
	end

	def leer()

		error = false

		for i in (0..(@file.length-1))
			j = superRegex =~ file[i]

			if ($&[0] == "#")
				next
			end

			tmp = Token.new($&, i, j+1)
			tokens.push(tmp)

			while ($' != "\n")
				prevColumn = tmp.str.length + tmp.column
				relPosition = superRegex =~ $'

				# VERIFICACION DE ERROR
				if (relPosition == nil)
					error = true
					tmp = Token.new($&, i, prevColumn)
					errorList.push(tmp)
					break
				end

				# VERIFICACION DE COMENTARIO
				if ($&[0] == "#")
					break
				end

				j = prevColumn + relPosition
				tmp = Token.new($&, i, j)
				tokens.push(tmp)
			end
		end

	end

