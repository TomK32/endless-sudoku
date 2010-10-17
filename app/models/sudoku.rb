# Sudoku is the most basic class and later extended by SolvedSudoku (pre-generated ones)
# and BoardSudoku (part of a board)
class Sudoku

  include Mongoid::Document
  include Mongoid::Timestamps

  field :rows, :type => Array
  field :parts, :type => Array
end
