require 'spec_helper'

describe BoardSudoku do
  it { should have_field(:solved).of_type(Boolean) }
  it { should have_field(:lng).of_type(Integer) }
  it { should have_field(:lat).of_type(Integer) }

  it { should be_referenced_in :board }
  it { should be_referenced_in :parent }


  it { should validate_presence_of :parent_id }
  it { should validate_presence_of :board_id }

  before do
    @solved_sudoku = Sudoku.generate
    @board = Board.create(:name => 'test')
  end

  it "should create sparse rows" do
    board_sudoku = BoardSudoku.create(:board => @board, :solved_sudoku => @solved_sudoku, :lat => 0, :lng => 0)
    board_sudoku.should be_valid
    board_sudoku.should_not be_solved
    board_sudoku.rows.collect{|r| r.match('0') }.compact.should_not be_empty
    board_sudoku.parts.collect{|r| r.match('0') }.compact.should_not be_empty
  end

  it "#generate" do
    board_sudoku = @board.sudokus.generate
    board_sudoku.should be_valid
    board_sudoku.should_not be_solved
    board_sudoku.parent.should_not be_nil
    board_sudoku.parent.should be_solved
  end
end

