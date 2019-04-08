class Importer
  def self.run(limit: 50)
    Feed.recent(limit: limit).find_each do |feed|
      feed.async_update
    end
  end

  def self.reload(feed: )
    feed.entries.delete_all
    feed.async_import
  end
end