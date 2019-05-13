class SearchController < BaseController
  # callbacks
  before_action :check_params

  def entries
    payload =  
      {
        query: {
          multi_match: {
            query:    params[:q], 
            fields: [ "title^3", "body^2", "url", "categories" ] 
          }
        }
      }

    @pagy, @entries = pagy_elasticsearch_rails(Entry.pagy_search(payload))

    json_response_with_serializer(@entries.records, Serializer::ENTRY)
  end

  def feeds
    payload =  
      {
        query: {
          multi_match: {
            query:    params[:q], 
            fields: [ "title", "description^2" ] 
          }
        }
      }

    @pagy, @feeds = pagy_elasticsearch_rails(Feed.pagy_search(payload))

    json_response_with_serializer(@feeds.records, Serializer::FEED)
  end

  private

  def check_params
    unless params[:q].present?
      json_error_response('Validation Failed', 'missing q param', :unprocessable_entity)
      return
    end
  end
end