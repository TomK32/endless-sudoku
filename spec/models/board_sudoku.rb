require 'spec_helper'

describe BoardSudoku do
  it { should have_field(:solved).of_type(Boolean) }

  it { should be_referenced_in :board }
  it { should be_referenced_in :parent }


  it { should validate_presence_of :solved_sudoku_id }

  before do
    @solved_sudoku = Sudoku.create_random
    @board = Board.create(:name => 'test')
  end

  it "should create sparse rows" do
    board_sudoku = BoardSudoku.create(:board => @board, :solved_sudoku => @solved_sudoku)
    sudoku.should be_valid
    sudoku.should_not be_solved
    sudoku.rows.collect{|r| r.match('0') }.compact.should_not be_empty
    sudoku.parts.collect{|r| r.match('0') }.compact.should_not be_empty
  end

  it "#create_random" do
    sudoku = board.sudokus.create_random
    sudoku.should be_valid
    sudoku.should_not be_solved
    sudoku.parent.should_not be_nil
    sudoku.parent.should be_solved
  end
end

