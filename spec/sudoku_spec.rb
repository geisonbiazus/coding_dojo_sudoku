require File.join(File.expand_path(File.dirname(__FILE__)), '..', 'src', 'sudoku')

describe "Sudoku" do

	before :each do
		@sudoku = Sudoku.new
		@board = [
			[9, 4, 7, 1, 6, 2, 3, 5, 8],
			[6, 1, 3, 8, 5, 7, 9, 2, 4],
			[8, 5, 2, 4, 9, 3, 1, 7, 6],
			[1, 2, 9, 3, 8, 4, 5, 6, 7],
			[5, 7, 8, 9, 2, 6, 4, 3, 1],
			[3, 6, 4, 7, 1, 5, 2, 8, 9],
			[2, 9, 1, 6, 3, 8, 7, 4, 5],
			[7, 8, 5, 2, 4, 1, 6, 9, 3],
			[4, 3, 6, 5, 7, 9, 8, 1, 2],
		]
	end

	it "should accept a valid board" do
		@sudoku.board = @board
		expect(@sudoku.validate).to be_true
		expect(@sudoku.errors).to be_empty
	end

	it "should validate the first line of the board and return the error coordinates" do
		@board[0] = [1, 2, 1, 4, 5, 6, 7, 8, 9]

		@sudoku.board = @board
		expect(@sudoku.validate).to be_false
		expect(@sudoku.errors).to be_include([0, 0])
		expect(@sudoku.errors).to be_include([0, 2])		
	end

	it "should validate the other lines of the board and return the error coordinates" do
		@board[0] = [1, 2, 1, 4, 5, 6, 7, 8, 9]
		@board[1] = [2, 3, 4, 5, 6, 5, 8, 9, 1]

		@sudoku.board = @board
		expect(@sudoku.validate).to be_false
		expect(@sudoku.errors).to be_include([0, 0])
		expect(@sudoku.errors).to be_include([0, 2])
		expect(@sudoku.errors).to be_include([1, 3])
		expect(@sudoku.errors).to be_include([1, 5])
	end

	it "should validate the columns of the board and return the error coordinates" do
		board = [
			[1, 2, 3, 4, 5, 6, 7, 8, 9],
			[2, 3, 4, 5, 6, 7, 8, 9, 1],
			[3, 4, 5, 6, 7, 8, 9, 1, 2],
			[4, 5, 6, 7, 8, 9, 1, 2, 3],
			[5, 6, 7, 8, 9, 1, 2, 3, 4],
			[6, 7, 8, 9, 1, 2, 3, 4, 5],
			[7, 8, 9, 1, 2, 3, 4, 5, 6],
			[8, 9, 1, 2, 3, 4, 5, 6, 7],
			[1, 1, 2, 3, 4, 5, 6, 8, 8],
		]

		@sudoku.board = board
		expect(@sudoku.validate).to be_false
		expect(@sudoku.errors).to be_include([0, 0])
		expect(@sudoku.errors).to be_include([8, 0])
		expect(@sudoku.errors).to be_include([0, 7])
		expect(@sudoku.errors).to be_include([8, 7])
	end

	it "should validate the subboards and retrn the error coordinates" do
		board = [
			[9, 4, 7,   1, 6, 2,   3, 5, 8],
			[6, 1, 3,   8, 5, 7,   9, 2, 4],
			[8, 5, 9,   4, 9, 3,   1, 7, 6],
			
			[1, 2, 9,   3, 8, 4,   5, 6, 7],
			[5, 7, 8,   9, 2, 8,   4, 3, 1],
			[3, 6, 4,   7, 1, 5,   2, 8, 9],
			
			[2, 9, 1,   6, 3, 8,   7, 4, 5],
			[7, 8, 5,   2, 4, 1,   6, 9, 3],
			[4, 3, 6,   5, 7, 9,   8, 1, 2],
		]

		@sudoku.board = board
		expect(@sudoku.validate).to be_false
		expect(@sudoku.errors).to be_include([0, 0])
		expect(@sudoku.errors).to be_include([2, 2])
		expect(@sudoku.errors).to be_include([3, 4])
		expect(@sudoku.errors).to be_include([4, 5])
	end

	it "should not duplicate the error coordinate" do
		board = [
			[9, 4, 7,   1, 6, 2,   3, 5, 8],
			[6, 1, 3,   8, 5, 7,   9, 2, 4],
			[8, 5, 9,   4, 9, 3,   1, 7, 6],
			
			[1, 2, 9,   3, 8, 4,   5, 6, 7],
			[5, 7, 8,   9, 2, 8,   4, 3, 1],
			[3, 6, 4,   7, 1, 5,   2, 8, 9],
			
			[2, 9, 1,   6, 3, 8,   7, 4, 5],
			[7, 8, 5,   2, 4, 1,   6, 9, 3],
			[4, 3, 6,   5, 7, 9,   8, 1, 2],
		]

		@sudoku.board = board
		@sudoku.validate
		expect(@sudoku.errors.find_all {|e| e == [2, 2]}.length).to eql(1)
	end

	it "should ignore a field with 0" do
		@board[0][0] = 0
		@board[0][1] = 0

		@sudoku.board = @board
		@sudoku.validate
		expect(@sudoku.errors.find_all {|e| e == [0, 0]}.length).to eql(0)

		@board[1][1] = 0
		@sudoku.board = @board
		@sudoku.validate
		expect(@sudoku.errors.find_all {|e| e == [0, 0]}.length).to eql(0)

		@board[1][0] = 0
		@sudoku.board = @board
		@sudoku.validate
		expect(@sudoku.errors.find_all {|e| e == [0, 0]}.length).to eql(0)
	end

	it "should say if the board is completed" do
		@sudoku.board = @board
		expect(@sudoku).to be_complete

		@board[0][1] = 0
		@sudoku.board = @board
		expect(@sudoku).not_to be_complete
	end

end
