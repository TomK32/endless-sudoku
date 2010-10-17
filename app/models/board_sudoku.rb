class BoardSudoku < Sudoku
  field :solved, :type => Boolean
  field :start_holes, :type => Integer, :default => 30

  referenced_in :board
  referenced_in :parent, :class_name => 'Sudoku'

  validates_presence_of :board_id
  validates_presence_of :parent_id

  index :board_id
  index :_type

  def self.build_random(attributes = {})
    sudoku = self.new(attributes)
    sudoku.parent = Sudoku.generate(3, sudoku.parts)
    sudoku.shoot_it!
    sudoku
  end

  def shoot_it!
    self.rows = parent.rows
    start_holes.times do |i|
      rows[rand(size**2) ][rand(size**2)] = ''
    end
    self.solved = false
  end

  def correct?(row, col, number)
    parent.rows[row.to_i][col.to_i].to_s == number.to_s
  end

  def as_json(options = {})
    attributes.reject{|k,v| %w(parts rows _id).include?(k)}.
      merge({:rows => self.rows_as_strings, :id => self.id}).as_json(options)
  end
end