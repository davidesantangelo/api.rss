# frozen_string_literal: true

class StatsController < BaseController
  skip_before_action :require_authentication, only: [:index]

  # GET /stats
  def index
    @stats =
      {
        counters: counters,
        avg_feed_rank: Feed.avg_rank
      }

    json_success_response(@stats)
  end

  private
  

  def counters
    {
      entries: Feed.all.sum(:entries_count),
      feeds: Feed.all.size,
      tokens: Token.all.size
    }
  end
end
