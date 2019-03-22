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
      f.title = feed.title
      f.description = feed.description.strip
      f.image = feed.image
    end
  end

  def entries
    self.class.parse(url: self.url).entries rescue []
  end

  def import
    imported = entries.map do |entry|
      Entry.add(feed_id: self.id, entry: entry)
    end

    imported.size
  end
end
