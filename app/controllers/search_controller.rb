class SearchController < BaseController
  # callbacks
  before_action :check_params
  skip_before_action :require_authentication, only: [:entries]

  def entries
    boost_by_recency = { created_at: { scale: "7d", decay: 0.5 } }
    fields = [ "title^10", "body", "url^2", "categories" ]

    entries = Entry.pagy_search(params[:q], boost_by_recency: boost_by_recency, fields: fields).results
    @pagy, @entries = pagy_searchkick(entries)

    json_response_with_serializer(@entries, Serializer::ENTRY)
  end

  def feeds
    fields = [ "title^10", "description", "url^2" ]

    feeds = Feed.pagy_search(params[:q], boost_by: [:entries_count], fields: fields).results
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