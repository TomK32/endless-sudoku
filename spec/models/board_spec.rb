require 'spec_helper'

describe Board do
  it { should have_field(:name).of_type(String) }
  it { should validate_presence_of(:name) }
  it { should reference_many(:sudokus).stored_as(:array) }
  
  it "should add sudokus to a new board" do
    Board.new.sudokus.should be_empty
    
    Board.create!(:name => 'test').sudokus.count.should ==(5)
  end
end
