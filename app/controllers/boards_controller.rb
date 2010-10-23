class BoardsController < ApplicationController
  inherit_resources
  actions :show, :index, :new, :create
  respond_to :json, :html
  before_filter :create_user, :only => :create

  def show
    current_board = resource
    if resource.nil?
      flash[:error] = "No such board found"
      redirect_to new_resource_path and return
    end
    show!
  end

  def create
    create!
    current_board = resource
  end

  protected
  def collection
    end_of_association_chain.paginate(:page => params[:page], :per_page => 20)
  end
end
