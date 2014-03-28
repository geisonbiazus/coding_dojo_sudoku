class Sudoku

	attr_accessor :board
	attr_reader :errors

	def initialize
		@errors = []
	end

	def validate
		validate_lines
		validate_columns
		validate_subboards
		errors.empty?
	end

	private

	def validate_lines
		board.each_with_index do |line, x|
			line.each_with_index do |number, y|
				add_error(x, y) if invalid_sequence?(line, number)
			end
		end
	end

	def validate_columns
		board.first.each_index do |y|
			column = board.map {|line| line[y]}
			column.each_with_index do |number, x|
				add_error(x, y) if invalid_sequence?(column, number)
			end
		end
	end

	def validate_subboards
		new_board = [[],[],[],[],[],[],[],[],[]]

		board.each_with_index do |line, x|
			index = x / 3 * 3
			index -= 1
			line.each_with_index do |number, y|
				index += 1 if y % 3 == 0
				new_board[index] << [[x, y], number]
			end
		end

		new_board.each do |line|
			sequence = line.map {|n| n.last}
			line.each do |number|
				add_error(*number.first) if invalid_sequence?(sequence, number.last)
			end
		end

	end

	def invalid_sequence?(sequence, number)
		sequence.find_all {|n| n == number}.length > 1
	end

	def add_error(x, y)
		errors << [x, y] unless errors.detect {|e| e == [x, y]}
	end

end