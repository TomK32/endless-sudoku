require 'spec_helper'

describe Sudoku do
  it { should have_field(:rows).of_type(Array) }
  it { should have_field(:parts).of_type(Array) }

  it ".generate" do
    sudoku = Sudoku.generate
    sudoku.should be_valid
    sudoku.should be_solved

    (sudoku.parts.collect{|p| p.size }.sum).should ==(9)
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
  it ".random_diagonal" do
    parts = Sudoku.random_diagonal(2)
    parts.size.should == 2
    parts[0].size.should == 2
    parts[1].size.should == 2
    parts[0][0].should_not be_nil
    parts[1][1].should_not be_nil
  end

  it "#generate_rows_from_parts" do
    sudoku = Sudoku.generate(2)
    sudoku.should be_solved
    sudoku.rows[0][0].should == sudoku.parts[0][0][0]
    sudoku.rows[1][0].should == sudoku.parts[0][0][2]
    sudoku.rows[3][2].should == sudoku.parts[1][1][2]
    sudoku.rows[3][3].should == sudoku.parts[1][1][3]
  end
end
