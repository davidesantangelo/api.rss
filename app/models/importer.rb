class Importer
  def self.run
    feeds = Feed.enabled.where("last_import_at IS NULL OR last_import_at <= ? ", 4.hours.ago).order(entries_count: :desc).limit(50)

    feeds.find_each do |feed|
      feed.async_update
    end
  end
end