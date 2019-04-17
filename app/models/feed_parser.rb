class FeedParser
  def self.entries(url: , from: nil)
    results = Feed.parse(url: url).entries rescue []
  
    if from.present?
      results.select do |entry| 
        entry.published.to_i >= from.to_i
      end
    end
  
    results
  end
end