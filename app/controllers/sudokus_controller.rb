class SudokusController < ApplicationController
  inherit_resources
  defaults :resource_class => BoardSudoku
  actions :all
  belongs_to :board
  respond_to :json

  before_filter :create_user

  def update
    if resource.update_if_correct(params[:row].to_i, params[:col].to_i, params[:number])
      render :json => resource and return
    else
      render :json => {:error => 'Ew, that was wrong my dear friend.'} and return
    end
  end
end
