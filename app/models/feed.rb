class Feed < ApplicationRecord
  include W3CValidators
  extend Pagy::Search

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  include Searchable

  # scopes
  default_scope { order(created_at: :desc) }
  scope :newest, -> { enabled.where('created_at <= ?', 24.hours.ago) }

  # relations
  has_many :entries, dependent: :destroy
  has_many :logs, dependent: :destroy

  # enums
  enum status: %i[enabled disabled]

  # validations
  validates :url, presence: true
  validates :title, presence: true
  validates_associated :entries

  # class methods
  def self.parse(url:)
    url = url.gsub('feed://', '').gsub('feed:', '').strip

    Feedjira::Feed.parse(RestClient.get(url).body)
  rescue URI::InvalidURIError => e
    Rails.logger.error(e)
    nil
  rescue RestClient::ExceptionWithResponse => e
    Rails.logger.error(e)
    nil
  end

  def self.recent(limit: 50)
    unscoped.newest.limit(limit)
  end

  def self.popular(limit: 20)
    unscoped.enabled.order(entries_count: :desc).limit(limit)
  end

  def self.add(url:)
    feed = parse(url: url)

    return false unless feed

    feed = find_or_create_by(url: url) do |f|
      f.title = feed.title.to_s.strip
      f.description = feed.description.to_s.strip
      f.image = feed.try(:image)
      f.language = feed.try(:language)
    end

    feed.async_import

    feed
  end

  def self.validate(url:)
    FeedValidator.new.validate_uri(url)
  end

  # instance methods
  def import!(from: nil)
    log = Log.create!(feed: self)

    log.start!

    count = 0
    FeedParser.entries(url: url, from: from).each do |entry|
      created, entry = Entry.add(feed_id: id, entry: entry)
      if created
        count += 1
        entry.enrich
      end
    end

    log.stop!(entries_count: count)
  end

  def async_import
    ImportFeedWorker.perform_async(id)
  end

  def async_update
    UpdateFeedWorker.perform_async(id)
  end

  def language
    self[:language].to_s.split('-')[0]
  end
end
