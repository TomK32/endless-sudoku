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
  
  def create_user
    if current_user.nil?
      @current_user = User.create((params[:user]||{}).reject{|k,v| v.blank?})
      sign_in(:user, @current_user) if @current_user.valid?
    end
  end
end
