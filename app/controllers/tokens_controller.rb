# frozen_string_literal: true

class TokensController < BaseController
  skip_before_action :require_authentication, only: [:create]

  # POST /tokens
  def create
    @token = Token.create!(expires_at: 2.hours.since)

    json_response_with_serializer(@token, Serializer::TOKEN)
  end

  # POST /tokens/refresh
  def refresh
    if current_token.expires_at.present?
      current_token.expires_at = 2.hours.since
      current_token.save
    end

    json_response_with_serializer(current_token, Serializer::TOKEN)
  end

  # GET /tokens/current
  def current
    json_response_with_serializer(current_token, Serializer::TOKEN)
  end
end
