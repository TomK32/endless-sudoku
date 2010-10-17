class SudokusController < ApplicationController
  inherit_resources
  defaults :resource_class => BoardSudoku
  belongs_to :board
  respond_to :json
  
  def update
    if resource.correct?(params[:row], params[:col], params[:number])
      resource.rows[params[:row]][params[:col]] = params[:number]
      resource.save!
    end
  end
  protected
end
