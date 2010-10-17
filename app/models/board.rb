class Board
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, :type => String

  references_many :sudokus, :class_name => "BoardSudoku", :inverse_of => :board

  validates_presence_of :name

  after_create :assign_sudokus

  def assign_sudokus
    last_sudoku = nil
    self.sudokus = 2.times.collect do |i|
      parts = []
      parts = [[last_sudoku.parent.parts[-1][-1], nil, nil], [], []] if i > 0
      sudoku = self.sudokus.build_random(:board_id => self.id, :lng => i, :lat => i, :parts => parts)
      if i > 0
        (0..2).each do |row|
          (0..2).each do |col|
            offset = sudoku.size ** 2 - sudoku.size
            sudoku.rows[row][col] = last_sudoku.rows[offset + row][offset + col]
          end
        end
      end
      sudoku.save
      last_sudoku = sudoku
    end
  end

  def as_json(options = {})
    attributes.reject{|k,v| %w(_id).include?(k)}.merge({
      :sudokus => self.sudokus.collect(&:as_json),
      :id => self.id.to_s
    }).as_json(options)
  end

end