class BaseController < ApplicationController
  include Response
  include ExceptionHandler
  include Serializer
  include Pagy::Backend

  before_action :require_authentication

  def current_token
    @current_token ||= authenticate_token
  end

  def require_authentication
    authenticate_token || render_unauthorized("the access token provided is invalid or expired")
  end

  private
      
  def render_unauthorized(message)
    json_error_response(Response::ACCESS_TOKEN_EXCEPTION, message, :unauthorized)
  end

  def authenticate_token
    authenticate_with_http_token do |token, options|
      if api_token = Token.active.find_by(key: token)
        # Compare the tokens in a time-constant manner, to mitigate timing attacks.
        ActiveSupport::SecurityUtils.secure_compare(
                        ::Digest::SHA256.hexdigest(token),
                        ::Digest::SHA256.hexdigest(api_token.key))
        api_token
      end
    end
  end
end