require 'spec_helper'

describe Sudoku do
  it { should have_field(:rows).of_type(Array) }
  it { should have_field(:parts).of_type(Array) }
  
  it "#create_random" do
    sudoku = Sudoku.create_random
    sudoku.should be_valid

    sudoku.parts.size.should ==(9)
    sudoku.rows.size.should ==(9)
    # a long shot that never misses
    sudoku.rows[0].should_not == sudoku.rows[1]
    sudoku.rows[0].should_not == sudoku.rows[2]
    sudoku.rows[0].should_not == sudoku.rows[3]
    sudoku.rows[0].should_not == sudoku.rows[4]
    sudoku.rows[0].should_not == sudoku.rows[5]
    sudoku.rows[0].should_not == sudoku.rows[6]
    sudoku.rows[0].should_not == sudoku.rows[7]
    sudoku.rows[0].should_not == sudoku.rows[8]
    sudoku.rows[0].should_not == sudoku.rows[9]
  end
end
