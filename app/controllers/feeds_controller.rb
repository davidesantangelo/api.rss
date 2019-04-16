class FeedsController < BaseController
  # callbacks
  before_action :set_feed, only: [:show]

  # GET /feeds
  def index
    @pagy, feeds = pagy Feed.all 

    json_response_with_serializer(feeds, Serializer::FEED)
  end

  # GET /feeds/:id
  def show
    json_response_with_serializer(@feed, Serializer::FEED)
  end

  # POST /feeds
  def create
    @feed = Feed.add(url: feed_params[:url])
    json_response_with_serializer(@feed, Serializer::FEED)
  end

  # GET /feeds/popular
  def popular
    @feeds = Feed.popular

    json_response_with_serializer(@feeds, Serializer::FEED)
  end

  # GET /feeds/trending
  def trending
    @feeds = Feed.trending

    json_response_with_serializer(@feeds, Serializer::FEED)
  end

  private

  def feed_params
    params.permit(:url)
  end

  def set_feed
    @feed = Feed.find(params[:id])
  end
end
