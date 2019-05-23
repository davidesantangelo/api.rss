class StatsController < BaseController
  skip_before_action :require_authentication, only: [:index]

  # GET /stats
  def index
    @stats = 
      {
        entries_count: Feed.all.sum(:entries_count),
        feeds_count: Feed.all.size,
        tokens_count: Token.all.size
      }

    json_success_response(@stats)
  end
end
