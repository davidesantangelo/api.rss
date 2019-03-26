class Feed < ApplicationRecord
  include W3CValidators

  # relations
  has_many :entries, dependent: :destroy
  has_many :logs, dependent: :destroy

  # callbacks
  after_create :async_import
  
  # enums
  enum status: [ :created, :scheduled, :imported ]

  # class methods
  def self.parse(url: )
    Feedjira::Feed.parse(RestClient.get(url).body)
  rescue URI::InvalidURIError => e
    Rails.logger.error(e)
    nil
  rescue RestClient::ExceptionWithResponse => e
    Rails.logger.error(e)
    nil
  end 

  def self.add(url: )
    feed = parse(url: url)
    
    return false unless feed

    find_or_create_by(url: url) do |f|
      f.title = feed.title.strip
      f.description = feed.description.strip
      f.image = feed.image
    end
  end

  def self.validate(url: )
    FeedValidator.new.validate_uri(url)
  end

  # instance methods
  def import!(from: nil)
    log = Log.create!(feed: self)

    log.start!

    entries_array =
      fetch_entries(from: from).map do |entry|
        Entry.add(feed_id: self.id, entry: entry)
      end

    log.stop!(entries_count: entries_array.size)
  end

  def enrich!
    self.entries.where(enriched_at: nil).map do |entry|
      entry.enrich
      entry
    end
  end

  def async_import
    ImportFeedWorker.perform_async(self.id)
  end

  private

  def fetch_entries(from: nil)
    results = self.class.parse(url: self.url).entries rescue []
    
    if from.present?
      results.select do |entry| 
        entry.published.to_i >= from.to_i
      end
    end

    results
  end
end
