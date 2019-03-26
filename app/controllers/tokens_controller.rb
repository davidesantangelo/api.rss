class TokensController < BaseController
  skip_before_action :require_authentication

  # POST /tokens
  def create
    @token = Token.create!(expires_at: 2.hours.since)

    json_response_with_serializer(@token, Serializer::TOKEN)
  end
end
