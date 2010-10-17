class SudokusController < ApplicationController
  def show
    # Find a board, return it
    # Dummy until we have a model in place
    sudoku =  {
      :fields => [
        123456789,
        123456789,
        123456789,
        123456789,
        123456789,
        123456789,
        123456789,
        123456789,
        123456789,
        123456789,
      ]
    }

    respond_to do |wants|
      wants.json { render :json => sudoku }
    end
  end
  
  def update
    
  end
end
