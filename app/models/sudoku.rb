# Sudoku is the most basic class and later extended by BoardSudoku (part of a board)
class Sudoku

  include Mongoid::Document
  include Mongoid::Timestamps

  field :rows, :type => Array, :default => []
  field :parts, :type => Array, :default => []
  field :solved, :type => Boolean, :default => false

  def validate
    errors.add('It must have 9 rows') unless self.rows.size.should == 9
    errors.add('It must have 9 fields') unless self.parts.size.should == 9
  end
  
  def self.generate(rows = 3)
    self.new(:parts => self.random_diagonal(rows))
  end
  def self.random_diagonal(rows = 3)
    parts = [];
    rows.times do |row|
      rows.times do |col|
        parts[row] ||= [];
        # We fill the diagonal
        parts[row][col] = self.random_part(rows) if row == col
      end
    end
    parts
  end
  
  # Note that for 4 and higher (that's 0..f) we will actually output 1..g
  def self.random_part(rows = 3)
    numbers = Range.new(1, rows**2).to_a
    Range.new(1, rows**2).to_a.
      map{|i| numbers.slice!(rand(numbers.size)).to_s([10,rows**2+1].max) }.
      compact.join('').to_s
  end
end
