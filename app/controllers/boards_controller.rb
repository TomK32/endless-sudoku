class BoardsController < ApplicationController
  inherit_resources
  actions :show, :index, :new, :create
  respond_to :json, :html
  before_filter :create_user, :only => :create

  def show
    current_board = resource
    show!
  end

  def create
    current_board = resource
    create!
  end

  protected
  def collection
    end_of_association_chain.paginate(:page => params[:page], :per_page => 20)
  end
end
