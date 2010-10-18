class SudokusController < ApplicationController
  inherit_resources
  defaults :resource_class => BoardSudoku
  actions :all
  belongs_to :board
  respond_to :json

  before_filter :create_user

  def update
    if resource.update_if_correct(params[:row].to_i, params[:col].to_i, params[:number])
      current_user.score ||= 0
      current_user.score += 1
      current_user.save
      render :json => {:sudoku => resource, :user => {:score => current_user.score}} and return
    else
      render :json => {:error => 'Ew, that was wrong my dear friend.'} and return
    end
  end
end
