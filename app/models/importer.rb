class Importer
  def self.run
    Feed.recent.find_each do |feed|
      feed.async_update
    end
  end
end