require 'spec_helper'

describe BoardsController do
  describe '#index' do
  end
  describe "get 'show'" do
    before do
      @board = Board.create!(:name => 'test')
      get 'show', :id => @board.id, :format => :json
    end

    it 'should be successful' do
      response.should be_successful
    end

    it 'should return JSON' do
      response.content_type.should == 'application/json'
    end
  end
end
