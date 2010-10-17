class BoardSudoku < Sudoku
  field :solved, :type => Boolean

  referenced_in :board
  referenced_in :parent, :class_name => 'Sudoku'

  def self.create_random
    self.create
  end
end