class BaseController < ApplicationController
  include Response
  include ExceptionHandler
  include Serializer
  include Pagy::Backend

  before_action :require_authentication

  attr_reader :api_key

  def current_token
    @current_token ||= authenticate_token
  end

  def require_authentication
    authenticate_token || render_unauthorized("the access token provided is invalid.")
  end

  private
      
  def render_unauthorized(message)
    json_error_response(Response::ACCESS_TOKEN_EXCEPTION, message, :unauthorized)
  end

  def decode_token_payload(token)
    payload, header = JWT.decode token, ENV['app_secret'], true, { algorithm: 'HS256' }

    payload
  rescue JWT::DecodeError
    {}
  end

  def authenticate_token
    authenticate_with_http_token do |token, options|
      decode_token_payload(token).fetch('api_key', nil) == ENV['api_key']
    end
  end
end