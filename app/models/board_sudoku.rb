class BoardSudoku < Sudoku
  field :solved, :type => Boolean

  referenced_in :board

  def self.create_random
    self.create
  end
end