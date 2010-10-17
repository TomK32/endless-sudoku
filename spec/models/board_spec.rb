require 'spec_helper'

describe Board do
  it { should have_field(:name).of_type(String) }
  it { should validate_presence_of(:name) }
  it { should reference_many(:sudokus) }
  
  it "should add sudokus to a new board" do
    Board.new.sudokus.should be_empty
    
    board = Board.create!(:name => 'test')
    board.sudokus.count.should ==(2)
    board.sudokus.map{|s| s.should_not be_solved }
  end
end
