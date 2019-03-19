require 'w3c_validators'

class Feed < ApplicationRecord
  include W3CValidators

  has_many :entries
  
  def self.feed_parse(url: )
    Feedjira::Feed.parse(RestClient.get(url).body) rescue nil
  end

  def entries
    result = self.class.feed_parse(url: self.url)
    
    return [] unless result

    result.entries
  end

  def import
    entries.each do |entry|
      Entry.add(feed_id: self.id, entry: entry)
    end
  end
end
