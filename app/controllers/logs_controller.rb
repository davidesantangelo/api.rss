# frozen_string_literal: true

class LogsController < BaseController
  # callbacks
  before_action :set_feed
  before_action :set_feed_log, only: [:show]

  # GET /feeds/:id/logs.json
  def index
    @pagy, logs = pagy Log.where(feed_id: params[:feed_id])

    json_response_with_serializer(logs, Serializer::LOG)
  end

  # GET /feeds/:id/logs/:id.json
  def show
    json_response_with_serializer(@log, Serializer::LOG)
  end

  private

  def set_feed
    @feed = Feed.find(params[:feed_id])
  end

  def set_feed_log
    @log = @feed.logs.find_by!(id: params[:id]) if @feed
  end
end
