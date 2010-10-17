class ApplicationController < ActionController::Base
  protect_from_forgery
  
  protected
  def current_board
    return if session[:board_id].blank?
    @current_board ||= Board.find(session[:board_id])
  end
  def current_board=(board)
    session[:board_id] = board.id
    @current_board = board
  end
end
