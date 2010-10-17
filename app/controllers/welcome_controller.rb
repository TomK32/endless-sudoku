class WelcomeController < ApplicationController
  def index
    if ! current_board
      redirect_to boards_path
    else
      redirect_to board_path(current_board)
    end
  end

end
