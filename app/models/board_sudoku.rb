class BoardSudoku < Sudoku
  field :solved, :type => Boolean
  field :start_holes, :type => Integer, :default => 30

  referenced_in :board
  referenced_in :parent, :class_name => 'Sudoku'

  def self.create_random
    sudoku = self.new
    sudoku.parent = Sudoku.generate
    sudoku.shoot_it!
    sudoku
  end

  def shoot_it!()
    self.rows = parent.rows
    start_holes.times do |i|
      rows[rand(size)][rand(size)] = nil
    end
    self.solved = false
  end
end