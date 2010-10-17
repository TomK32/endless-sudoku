require 'spec_helper'

describe BoardSudoku do
  it { should have_field(:solved).of_type(Boolean) }

  it { should be_referenced_in :board }
  it { should be_referenced_in :solved_sudoku }


  it { should validate_presence_of :solved_sudoku_id }

  it "should create sparse rows" do
    board = Board.create(:name => 'test')
    solved_sudoku = Sudoku.create_random
    board_sudoku = BoardSudoku.create(:board => board, :solved_sudoku => solved_sudoku)
  end
end

