class SearchController < BaseController
  # callbacks
  before_action :check_params
  skip_before_action :require_authentication, only: [:entries]

  def entries
    entries = Entry.pagy_search(params[:q], fields: [ "title^10", "body", "url^2", "categories" ]).results
    @pagy, @entries = pagy_searchkick(entries)

    json_response_with_serializer(@entries, Serializer::ENTRY)
  end

  def feeds
    feeds = Feed.pagy_search(params[:q], fields: [ "title^10", "description", "url^2" ]).results
    @pagy, @feeds = pagy_searchkick(feeds)

    json_response_with_serializer(@feeds, Serializer::FEED)
  end

  private

  def check_params
    unless params[:q].present?
      json_error_response('Validation Failed', 'missing q param', :unprocessable_entity)
      return
    end
  end
end