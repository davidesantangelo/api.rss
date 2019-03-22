class Feed < ApplicationRecord
  has_many :entries, dependent: :destroy
  
  def self.parse(url: )
    Feedjira::Feed.parse(RestClient.get(url).body)
  rescue RestClient::ExceptionWithResponse => e
    e.response
  end

  def self.add(url: )
    feed = parse(url: url)
    
    find_or_create_by(url: url) do |f|
      f.title = feed.title.strip
      f.description = feed.description.strip
      f.image = feed.image
    end
  end

  def import!
    fetch_entries.map do |entry|
      Entry.add(feed_id: self.id, entry: entry)
    end
  end

  def enrich!
    self.entries.where(enriched_at: nil).map do |entry|
      entry.enrich
      entry
    end
  end

  private

  def fetch_entries
    self.class.parse(url: self.url).entries rescue []
  end
end
