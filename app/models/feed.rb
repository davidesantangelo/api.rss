class Feed < ApplicationRecord
  searchkick

  extend Pagy::Search

  include W3CValidators
  include Searchable
  
  # scopes
  default_scope { order(created_at: :desc) }
  scope :newest, -> { enabled.where('created_at <= ?', 24.hours.ago) }

  # relations
  has_many :entries, dependent: :destroy
  has_many :logs, dependent: :destroy
  has_many :webhook_endpoints, class_name: 'Webhook::Endpoint'
  
  # enums
  enum status: %i[enabled disabled]

  # validations
  validates :url, presence: true
  validates :title, presence: true
  validates_associated :entries

  # class methods
  def self.parse(url:)
    url = url.gsub('feed://', '').gsub('feed:', '').strip
    Feedjira.parse(RestClient.get(url).body)
  rescue Feedjira::NoParserAvailable => e
    Rails.logger.error(e)
    nil
  rescue URI::InvalidURIError => e
    Rails.logger.error(e)
    raise e
  rescue RestClient::ExceptionWithResponse => e
    Rails.logger.error(e)
    raise e
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

    feed.enrich
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

  def enrich
    domain_rank = Service::Metric.rank(domain).abs

    self.rank = domain_rank.zero? ? 0 : ((Math::log10(domain_rank) / Math::log10(Feed.maximum(:rank))) * 100).round

    save!
  end

  def domain
    url = self.url.gsub('feed://', '').gsub('feed:', '').strip
    url = "http://#{url}" if URI.parse(url).scheme.nil?

    PublicSuffix.domain(URI.parse(url).host)
  rescue StandardError
    nil
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
