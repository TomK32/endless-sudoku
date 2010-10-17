class BoardsController < ApplicationController
  inherit_resources
  actions :show, :index

  def show!
    @sudokus = resource.sudokus.all
    show!
  end

  protected
end
