class Feed < ApplicationRecord
  include W3CValidators

  # relations
  has_many :entries, dependent: :destroy
  has_many :logs, dependent: :destroy

  # callbacks
  after_create :async_import
  
  # enums
  enum status: [ :enabled, :disabled ]

  # validations
  validates :url, presence: true
  validates :title, presence: true
  validates_associated :entries

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

  def self.recent(limit: 50)
    enabled.where("last_import_at IS NULL OR last_import_at <= ? ", 4.hours.ago).limit(limit)
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
      created, entry = Entry.add(feed_id: self.id, entry: entry)
      if created
        count += 1 
        entry.enrich
      end
    end

    log.stop!(entries_count: count)
  end

  def async_import
    ImportFeedWorker.perform_async(self.id)
  end

  def async_update
    UpdateFeedWorker.perform_async(self.id)
  end

  def language
    self[:language].to_s.split("-")[0]
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
