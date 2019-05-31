class Entry < ApplicationRecord
  searchkick settings: { index: { max_result_window: 110000 } }
  
  extend Pagy::Search
  
  include Webhook::Observable
  include ActionView::Helpers::SanitizeHelper
  include Searchable

  # scopes
  default_scope { order(created_at: :desc) }

  scope :enriched, -> { where.not(enriched_at: nil) }
  scope :newest, -> { where("created_at <= ?", 24.hours.ago) }

  # relations
  belongs_to :feed, counter_cache: true

  # validations
  validates :url, presence: true
  validates :title, presence: true
  validates_uniqueness_of :url
  
  # class methods
  def self.add(feed_id: , entry: )
    return [ false, nil ] if find_by(url: entry.url)

    attrs = {
      feed_id: feed_id,
      title: entry.title.blank? ? 'untitled' : entry.title,
      body: entry.summary,
      url: entry.url,
      external_id: entry.entry_id,
      categories: categories(entry: entry).map(&:downcase),
      published_at: entry.published || Time.current
    }

    entry = create!(attrs)

    [true, entry]
  end

  def self.categories(entry: )
    res = entry.try(:categories)
    res.to_a.join(",").split(",").flatten.map(&:strip)
  rescue StandardError
    []
  end

  # instance methods  
  def as_indexed_json(_options = {})
    as_json(except: ['annotations'])
  end

  def tags
    return [] unless self.annotations.present?
    
    self.annotations.uniq { |h| h['id'] }.map do |annotation|
      {
        uri: annotation.dig('uri'),
        spot: annotation.dig('spot'),
        label: annotation.dig('label'),
        confidence: annotation.dig('confidence'),
        categories: annotation.dig('categories')
      }
    end
  end

  def text
    return title unless body.present?

    strip_tags(body).to_s.strip
  end

  def enrich
    annotations = get_annotations
    sentiment = get_sentiment

    self.annotations = annotations
    self.sentiment = sentiment
    self.enriched_at = Time.current
    
    save!
  end

  private

  def webhook_scope
    feed
  end

  def webhook_payload
    { entry: self }
  end

  def get_annotations
    Service::Dandelion.annotations(text: self.text)
  end

  def get_sentiment
    Service::Dandelion.sentiment(text: self.text)
  end
end
