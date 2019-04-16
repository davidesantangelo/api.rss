class Feed < ApplicationRecord
  include W3CValidators
  extend Pagy::Search
  
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  include ActionView::Helpers::SanitizeHelper

  # scopes
  default_scope { order(created_at: :desc) }
  
  # relations
  has_many :entries, dependent: :destroy
  has_many :logs, dependent: :destroy
  
  # enums
  enum status: [ :enabled, :disabled ]

  # validations
  validates :url, presence: true
  validates :title, presence: true
  validates_associated :entries

  # elastic search callbacks
  after_commit on: [:create] do
    __elasticsearch__.index_document 
  end

  after_commit on: [:update] do
    __elasticsearch__.update_document
  end

  after_commit on: [:destroy] do
    __elasticsearch__.delete_document 
  end

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

    feed = find_or_create_by(url: url) do |f|
      f.title = feed.title.strip
      f.description = feed.description.strip
      f.image = feed.image
      f.language = feed.language
    end

    feed.async_import

    feed
  end

  def self.validate(url: )
    FeedValidator.new.validate_uri(url)
  end

  # instance methods
  def import!(from: nil)
    log = Log.create!(feed: self)

    log.start!

    count = 0
    FeedParser.entries(url: self.url, from: from).each do |entry|
      created, entry = Entry.add(feed_id: self.id, entry: entry)
      if created
        count += 1 
        entry.enrich
      end
    end

    log.stop!(entries_count: count)
  end

  def as_indexed_json(options = {})
    as_json
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
end
