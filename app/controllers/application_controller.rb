# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def generate_jwt_token(user)
    payload = { user_id: user.id }
    JWT.encode(payload, Rails.application.config.secret_key_base, 'HS256')
  end

  def authenticate_with_jwt_token
    token = request.headers['Authorization']
    begin
      payload, = JWT.decode(token, Rails.application.config.secret_key_base, ['HS256'])
      @current_user = User.find(payload['user_id'])
    rescue JWT::VerificationError, JWT::DecodeError
      render json: { error: 'Invalid token' }, status: :unauthorized
    end
  end

  def verify_status
    return unless logged_in?
    return if current_user.status

    render json: { message: 'User not active' }, status: :unauthorized
  end

  def require_user
    return if logged_in?

    render json: { message: 'Login required' }
  end
end
