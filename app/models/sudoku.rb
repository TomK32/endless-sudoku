# Sudoku is the most basic class and later extended by BoardSudoku (part of a board)
class Sudoku

  include Mongoid::Document
  include Mongoid::Timestamps

  field :rows, :type => Array, :default => []
  field :parts, :type => Array, :default => []

  def validate
    errors.add('It must have 9 rows') unless self.rows.size.should == 9
    errors.add('It must have 9 fields') unless self.parts.size.should == 9
  end
end
