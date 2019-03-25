class EntriesController < BaseController
  # callbacks
  before_action :set_feed
  before_action :set_feed_entry, only: [:show]

  # GET /feeds/:id/entries.json
  def index
    @pagy, entries = pagy Entry.where(feed_id: params[:feed_id]) 

    json_response_with_serializer(entries, Serializer::ENTRY)
  end

  # GET /feeds/:id/entries/:id.json
  def show
    json_response_with_serializer(@entry, Serializer::ENTRY)
  end

  private

  def set_feed
    @feed = Feed.find(params[:feed_id])
  end

  def set_feed_entry
    @entry = @feed.entries.find_by!(id: params[:id]) if @feed
  end
end
