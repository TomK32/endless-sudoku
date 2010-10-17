require 'spec_helper'

describe WelcomeController do

  describe "GET 'index'" do
    it "without board_in in session" do
      get 'index'
      response.should be_redirect
    end
    it "with board_id in session"
  end
end
