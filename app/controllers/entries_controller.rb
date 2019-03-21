class EntriesController < BaseController
  # callbacks
  before_action :set_entry, only: [:show]

  # GET /feeds/:id/entries.json
  def index
    _, entries = pagy Entry.where(feed_id: params[:feed_id]) 

    json_response_with_serializer(entries, Serializer::ENTRY)
  end

  # GET /feeds/:id/entries/:id.json
  def show
    json_response_with_serializer(@entry, Serializer::ENTRY)
  end

  private

  def set_entry
    @entry = Entry.where(feed_id: params[:feed_id]).find(params[:id])
  end
end
