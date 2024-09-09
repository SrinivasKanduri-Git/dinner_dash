# frozen_string_literal: true

class SessionController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_with_jwt_token, only: [:destroy]
  def create
    user = User.find_by(email: params[:session][:email])
    if user&.authenticate(params[:session][:password])
      session[:user_id] = user.id
      token = generate_jwt_token(user)
      render json: { user:, token: }
    else
      render json: { errors: 'Invalid email or password' }, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    render json: { message: 'logged out successfully.' }
  end
end
