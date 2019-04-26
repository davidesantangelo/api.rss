class BaseController < ApplicationController
  include Response
  include ExceptionHandler
  include Serializer
  include Pagy::Backend

  before_action :require_authentication, unless: :ip_whitelisted?

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

  def ip_whitelisted?
    IpWhitelist.enabled?(ip_address: request.env['HTTP_X_REAL_IP'] || request.env['REMOTE_ADDR'])
  end

  def authenticate_token
    authenticate_with_http_token do |token, _|
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