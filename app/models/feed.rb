class Feed < ApplicationRecord
  include W3CValidators

  # relations
  has_many :entries, dependent: :destroy
  has_many :logs, dependent: :destroy

  # callbacks
  after_create :async_import
  
  # enums
  enum status: [ :enabled, :disabled ]

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
      f.language = feed.language
    end
  end

  def self.validate(url: )
    FeedValidator.new.validate_uri(url)
  end

  # instance methods
  def import!(from: nil)
    log = Log.create!(feed: self)

    log.start!

    count = 0
    fetch_entries(from: from).each do |entry|
      created = Entry.add(feed_id: self.id, entry: entry)
      count += 1 if created
    end

    log.stop!(entries_count: count)
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

  def async_update
    UpdateFeedWorker.perform_async(self.id)
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
