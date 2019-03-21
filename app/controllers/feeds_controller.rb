class FeedsController < BaseController
  # callbacks
  before_action :set_feed, only: [:show]

  # GET /feeds.json
  def index
    _, feeds = pagy Feed.all 

    json_response_with_serializer(feeds, Serializer::FEED)
  end

  # GET /feeds/:id.json
  def show
    json_response_with_serializer(@feed, Serializer::FEED)
  end

  private

  def set_feed
    @feed = Feed.find(params[:id])
  end
end
