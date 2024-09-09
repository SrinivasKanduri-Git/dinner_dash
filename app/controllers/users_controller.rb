# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, except: %i[show my_cart]
  before_action :authenticate_with_jwt_token, except: [:create]
  before_action :find_user, only: %i[show update destroy status_update]
  before_action :set_user, only: %i[my_cart add_item remove_item]
  before_action :require_user, except: %i[show create]
  before_action :require_same_user, only: %i[show update status_update]
  before_action :verify_status, except: %i[show status_update]
  def show
    render json: @user
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      token = generate_jwt_token(@user)
      render json: { user: @user, token: }
    else
      render json: { errors: @user.errors.full_messages }
    end
  end

  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: { errors: @user.errors.full_messages }
    end
  end

  def status_update
    @user.update(status: true)
    render json: { message: 'User is now active' }
  end

  def destroy
    session[:user_id] = nil
    @user.destroy
    render json: { message: 'User deleted' }
  end

  def my_cart
    render json: @user.cart.items
  end

  def add_item
    @user.cart.items << Item.find(params[:id])
    render json: @user.cart.items
  end

  def remove_item
    @user.cart.items.delete(Item.find(params[:item_id]))
    render json: { message: 'Item removed from cart' }
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def set_user
    @user = User.find(session[:user_id])
  end

  def require_same_user
    return unless current_user != User.find(params[:id])

    render json: { errors: 'Not same user' }
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :dob, :password, phone_number: [])
  end
end
