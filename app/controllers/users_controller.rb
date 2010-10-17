class UsersController < ApplicationController
  inherit_resources
  actions :all
  before_filter :authenticate_user!
  respond_to :json, :html
  
  def index
    render :json => {:users_count => User.count}
  end
  
  def update
    update!{ redirect_to user_path(current_user.id, :format => :json) and return }
  end

  protected
  def resource
    current_user
  end
end