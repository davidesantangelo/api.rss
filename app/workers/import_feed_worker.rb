class ImportFeedWorker
  include Sidekiq::Worker

  def perform(feed_id)
    feed = Feed.find(feed_id)

    feed.import!
    feed.enrich!
  end
end
