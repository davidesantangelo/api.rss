class SearchController < BaseController
  # callbacks
  before_action :check_params
  skip_before_action :require_authentication, only: [:entries]

  def entries
    boost_by_recency = { created_at: { scale: "4d", decay: 0.5 } }
    fields = [ "title^8", "body^2", "url^4", "categories" ]

    entries = Entry.pagy_search(params[:q], where: build_filters, boost_by_recency: boost_by_recency, order: build_order, fields: fields).results
    @pagy, @entries = pagy_searchkick(entries)

    json_response_with_serializer(@entries, Serializer::ENTRY)
  rescue StandardError => e
    json_error_response('SearchEntriesError', e.message, 500)
  end

  def feeds
    fields = [ "title^8", "description", "url^4" ]

    feeds = Feed.pagy_search(params[:q], boost_by: [:entries_count, :rank], fields: fields).results
    @pagy, @feeds = pagy_searchkick(feeds)

    json_response_with_serializer(@feeds, Serializer::FEED)
  rescue StandardError => e
    json_error_response('SearchFeedsError', e.message, 500)
  end

  private
  
  def build_order
    order = {}

    order.merge!(published_at: entries_params[:order]) if entries_params[:order].present?
    
    order
  end

  def build_filters
    filters = {}

    range = {}

    range.merge!(gte: Time.parse(entries_params[:from])) if entries_params[:from].present?
    range.merge!(lte: Time.parse(entries_params[:to])) if entries_params[:to].present?

    filters.merge!(feed_id: entries_params[:feed_id]) if entries_params[:feed_id].present?
    filters.merge!(published_at: range)

    filters
  end

  def entries_params
    params.permit(:q, :from, :to, :feed_id, :order)
  end

  def check_params
    unless entries_params[:q].present?
      json_error_response('Validation Failed', 'missing q param', :unprocessable_entity)
      return
    end

    if entries_params[:order].present? && !%w(asc desc).include?(entries_params[:order])
      json_error_response('Validation Failed', 'order param must be asc/desc', :unprocessable_entity)
      return
    end
  end
end