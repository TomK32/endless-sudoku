class WelcomeController < ApplicationController
  def index
    current_board = Board.last if ! current_board
    redirect_to board_path(current_board)
  end
end
