class UsersController < ApplicationController
  inherit_resources
  actions :all
  before_filter :authenticate_user!, :except => :index
  respond_to :json, :html

  def edit
    @user = current_user
    edit!
  end

  def update
    @user = current_user
    update!{ redirect_to user_path(current_user.id, :format => :json) and return }
  end

  protected
  def collection
    end_of_association_chain.where(:name.exists => true, :score.exists => true).
      order_by([:score, :desc]).
      paginate(:per_page => 20, :page => params[:page])
  end
end