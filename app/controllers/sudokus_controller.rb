class SudokusController < ApplicationController
  inherit_resources
  defaults :resource_class => BoardSudoku
  actions :all
  belongs_to :board
  respond_to :json
  
  def update
    if resource.correct?(params[:row], params[:col], params[:number])
      resource.rows[params[:row]][params[:col]] = params[:number]
      raise resource.rows.join("\n")
      if resource.save
        render :json => resource and return
      end
    else
      render :json => {:error => 'Ew, that was wrong my dear friend.'} and return
    end
  end
  protected
end
