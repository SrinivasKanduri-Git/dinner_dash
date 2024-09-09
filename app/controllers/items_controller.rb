# frozen_string_literal: true

class ItemsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  before_action :authenticate_with_jwt_token
  before_action :verify_status
  before_action :require_user, except: [:create]

  def index
    @items = Item.all
    render json: @items
  end

  def search_with_category
    @items = Item.where(category: params[:id])
    render json: @items
  end

  def show
    @item = Item.find(params[:id])
    render json: @item
  end

  def create
    @item = Item.new(params.require(:item).permit(:title, :description, :price, { category_attributes: [:category] }))
    @item.category = Category.find_or_create_by(category: params[:category])
    if @item.save
      render json: @item, status: :created
    else
      render json: { errors: @item.errors.full_messages }
    end
  end
end
