class BoardSudoku < Sudoku
  field :solved, :type => Boolean
  field :start_holes, :type => Integer, :default => 40
  field :lat, :type => Integer
  field :lng, :type => Integer

  referenced_in :board
  referenced_in :parent, :class_name => 'Sudoku'

  validates_presence_of :board_id
  validates_presence_of :parent_id
  validates_presence_of :lat, :lng

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
      rows[rand(size**2)][rand(size**2)] = ' '
    end
    self.solved = false
  end

  def update_if_correct(row, col, number)
    if self.correct?(row, col, number)
      self.rows[row][col] = number.to_s
      self.collection.update({:_id => self.id}, {:"$set" => {"rows.#{row}" => self.rows[row]}}, {:upsert => true}
      ).inspect
      return self.save
    end
    return false
  end

  def correct?(row, col, number)
    parent.rows[row.to_i][col.to_i].to_s == number.to_s
  end

  def as_json(options = {})
    attributes.reject{|k,v| %w(parts _id).include?(k)}.
      merge({:id => self.id.to_s}).as_json(options)
  end
end