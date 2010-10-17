class BoardSudoku < Sudoku
  field :solved, :type => Boolean
  field :start_holes, :type => Integer, :default => 30

  referenced_in :board
  referenced_in :parent, :class_name => 'Sudoku'

  validates_presence_of :board_id
  validates_presence_of :parent_id

  index :board_id
  index :_type

  def self.create_random(attributes = {})
    sudoku = self.new(attributes)
    sudoku.parent = Sudoku.generate
    sudoku.shoot_it!
    sudoku.save
    sudoku
  end

  def shoot_it!()
    self.rows = parent.rows
    start_holes.times do |i|
      rows[rand(size)][rand(size)] = nil
    end
    self.solved = false
  end

  def as_json(options = {})
    attributes.reject{|k,v| %w(parts rows).include?(k)}.
      merge({:rows => self.rows_as_strings}).as_json(options)
  end
end