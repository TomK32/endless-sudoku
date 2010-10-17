class BoardsController < ApplicationController
  inherit_resources
  actions :show, :index, :new, :create
  respond_to :json, :html

  protected
end
