# Sudoku is the most basic class and later extended by BoardSudoku (part of a board)
class Sudoku

  include Mongoid::Document
  include Mongoid::Timestamps

  field :rows, :type => Array, :default => []
  field :parts, :type => Array, :default => []
  field :solved, :type => Boolean, :default => false

  before_save :convert_rows_to_strings

  def validate
    errors.add('It must have 9 rows') unless self.rows.size.should == 9
    errors.add('It must have 9 fields') unless self.parts.size.should == 9
  end

  def size
    @size ||= [(parts||[]).size, Math.sqrt(rows.size||1)].max
  end

  def convert_rows_to_strings
    self.rows = rows.collect{|r| r.is_a?(String) ? r : r.join('') }
  end

  def generate_rows_from_parts
    (size**2).times do |row|
      self.rows[row] ||= []
      (size**2).times do |col|
        self.rows[row][col] = if !self.parts[row/size][col/size].blank?
           self.parts[row/size][col/size][col%size + (row%size*size)].to_i
        else
          nil
        end
      end
    end
  end
  def generate_parts_from_rows
    size.times do |row|
      size.times do |col|
        self.parts[row][col] =
          (0...size**2).to_a.collect do |col2|

            self.rows[(col*size) + (col2 / size)][(row*size)+col2%size]
          end
      end

    end
  end

  def self.generate(rows = 3, parts = [])
    sudoku = self.new(:parts => self.random_diagonal(rows, parts))
    sudoku.generate_rows_from_parts
    sudoku.rows = SudokuSolver::Solver.solve(sudoku.rows)
    sudoku.solved = true
    sudoku.generate_parts_from_rows
    sudoku.save
    sudoku
  end

  def self.random_diagonal(rows = 3, parts = [])
    parts ||= []
    rows.times do |row|
      parts[row] ||= rows.times.collect{[]};
      # We fill the diagonal
      parts[row][row] = self.random_part(rows) if parts[row][row].nil? || parts[row][row].empty?
    end
    parts
  end

  # Note that for 4 and higher (that's 0..f) we will actually output 1..g
  def self.random_part(rows = 3)
    numbers = Range.new(1, rows**2).to_a
    (rows**2).times.
      collect{|i| numbers.slice!(rand(numbers.size)).to_s([10,rows**2+1].max) }.compact.join('')
  end

  def rows_as_strings(separator = '', filler = ' ')
    self.rows.join(separator)
  end
  def rows_to_s
    self.rows_as_strings(' ').join("\n")
  end
  def parts_to_s
    (0...(size**2)).to_a.collect do |row|
      s = (0...(size**2)).to_a.collect do |col|
        if !self.parts[row/size][col/size].blank?
          self.parts[row/size][col/size][col%size + (row%size*size)]
        else
          '-'
        end
      end.join(' ')
      s
    end.join("\n")
  end
end
