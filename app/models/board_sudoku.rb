class BoardSudoku < Sudoku
  field :solved, :type => Boolean

  referenced_in :board
end