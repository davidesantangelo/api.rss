class BaseController < ApplicationController
  include Response
  include ExceptionHandler
  include Serializer
  include Pagy::Backend

  before_action :require_authentication

  attr_reader :api_key

  APP_SECRET = ENV['app_secret']
  APP_TOKEN = ENV['app_token']

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

  def decoded_app_token(token)
    payload, _ = JWT.decode token, APP_SECRET, true, { algorithm: 'HS256' }

    app_token = payload.fetch('api_key', nil)

    app_token
  rescue JWT::DecodeError
    nil
  end

  def authenticate_token
    authenticate_with_http_token do |token, options|
      if app_token = decoded_app_token(token)
        # Compare the tokens in a time-constant manner, to mitigate timing attacks.
        ActiveSupport::SecurityUtils.secure_compare(
          ::Digest::SHA256.hexdigest(token),
          ::Digest::SHA256.hexdigest(app_token))

        app_token == APP_TOKEN
      end
    end
  end
end