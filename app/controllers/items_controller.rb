class ItemsController < ApplicationController

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  def index
  if params[:user_id]
    user = User.find_by!(id: params[:user_id])
    items = user.items
  else
    items = Item.all
  end
    render json: items, include: :user
  end
  
  def show
    if params[:user_id]
      user = User.find_by!(id: params[:user_id])
      item = user.items.find_by!(id: params[:id])
    else
      item = Item.find_by!(id: params[:id])
    end
      render json: item
      # , include: :user
  end

  def create
    user = User.find_by!(id: params[:user_id])
    new_item = user.items.create(item_params)
    render json: new_item, status: :created
  end
    

  private
  
  def render_not_found_response
    render json: { error: "User not found" }, status: :not_found
  end

  def item_params
    params.permit(:name, :description, :price)
  end

end
