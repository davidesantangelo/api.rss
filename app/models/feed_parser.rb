class FeedParser
  def self.entries(url: , from: nil)
    results = Feed.parse(url: clean_url(url: url)).entries rescue []
  
    if from.present?
      results.select do |entry| 
        entry.published.to_i >= from.to_i
      end
    end
  
    results
  end

  def self.clean_url(url: )
    url
      .strip
      .gsub("feed://","")
      .gsub("feed:","")
  end
end