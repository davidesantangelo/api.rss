class SearchController < BaseController
  def entries

    unless params[:q].present?
      json_error_response('Validation Failed', 'missing q param', :unprocessable_entity)
      return
    end

    payload =  
      {
        query: {
          multi_match: {
            query:    params[:q], 
            fields: [ "title", "body^2" ] 
          }
        }
      }

    @pagy, @entries = pagy_elasticsearch_rails(Entry.pagy_search(payload))

    json_response_with_serializer(@entries.records, Serializer::ENTRY)
  end
end