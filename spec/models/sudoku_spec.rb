require 'spec_helper'

describe Sudoku do
  it { should have_field(:rows).of_type(Array) }
  it { should have_field(:parts).of_type(Array) }

  it ".generate" do
    sudoku = Sudoku.generate
    sudoku.should be_valid

    (sudoku.parts.collect(&:size).sum2).should ==(9)
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

  it ".random_part" do
    Sudoku.random_part.should be_a(String)
    Sudoku.random_part.size.should ==(9)
  end
  it ".random_part with rows" do
    Sudoku.random_part(2).should be_a(String)
    Sudoku.random_part(2).size.should ==(4)
  end
  it ".random_part for 1..F" do
    Sudoku.random_part(4).should be_a(String)
    Sudoku.random_part(4).size.should ==(16)
  end
end
