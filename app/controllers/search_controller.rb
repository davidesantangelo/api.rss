class SearchController < BaseController
  def entries
    records = Entry.pagy_search(params[:q]).records
    
    @pagy, @entries = pagy_elasticsearch_rails(records)

    json_response_with_serializer(@entries, Serializer::ENTRY)
  end
end