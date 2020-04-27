# frozen_string_literal: true

class WebhooksController < BaseController
  # callbacks
  before_action :set_feed
  before_action :set_feed_webhook, only: %i[show destroy]
  before_action :check_create_params, only: [:create]

  # GET /feeds/:id/webhooks
  def index
    @pagy, webhooks = pagy @feed.webhook_endpoints.all

    json_response_with_serializer(webhooks, Serializer::WEBHOOK)
  end

  # GET /feeds/:id/webhooks/:id
  def show
    json_response_with_serializer(@webhook, Serializer::WEBHOOK)
  end

  # POST /feeds/:id/webhooks
  def create
    @webhook = @feed.webhook_endpoints.create!(webhook_params)

    json_response_with_serializer(@webhook, Serializer::WEBHOOK)
  end

  # PATCH/PUT /feeds/:id/webhooks/:id
  def update
    @webhook = @feed.webhook_endpoints.update(webhook_params)

    json_response_with_serializer(@webhook, Serializer::WEBHOOK)
  end

  # DELETE /feeds/:id/webhooks
  def destroy
    @webhook.destroy

    head :no_content
  end

  private

  def check_create_params
    unless webhook_params[:url].present?
      json_error_response('Validation Failed', 'missing URL param', :unprocessable_entity)
      return
    end

    unless webhook_params[:events].present?
      json_error_response('Validation Failed', "missing events param (#{Webhook::Event::EVENT_TYPES.join(',')})", :unprocessable_entity)
      return
    end
  end

  def webhook_params
    params.permit(:url, events: [])
  end

  def set_feed
    @feed = Feed.find(params[:feed_id])
  end

  def set_feed_webhook
    @webhook = @feed.webhook_endpoints.find_by!(id: params[:id]) if @feed
  end
end
