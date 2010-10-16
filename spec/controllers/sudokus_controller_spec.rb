require 'spec_helper'

describe SudokusController do
  describe "get 'show'" do
    before do
      get 'show', :id => 1, :format => :json
    end

    it 'should be successful' do
      response.should be_successful
    end

    it 'should return JSON' do
      response.content_type.should == 'application/json'
    end
  end
end
