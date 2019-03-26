class Entry < ApplicationRecord
  extend Pagy::Search
  
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  include ActionView::Helpers::SanitizeHelper

  # scopes
  default_scope { order(created_at: :desc) }

  # relations
  belongs_to :feed, counter_cache: true

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
  def self.add(feed_id: , entry: )
    return false if find_by(url: entry.url)

    attrs = {
      feed_id: feed_id,
      title: entry.title,
      body: entry.summary,
      url: entry.url,
      external_id: entry.entry_id,
      categories: categories(entry: entry).map(&:downcase),
      published_at: entry.published
    }

    create!(attrs)

    true
  end

  def self.categories(entry: )
    res = entry.try(:categories)
    res.to_a.join(",").split(",").flatten.map(&:strip)
  rescue Exception
    []
  end

  # instance methods  
  def as_indexed_json(options = {})
    as_json(except: ['annotations', 'sentiment'])
  end

  def tags
    return [] if self.annotations.to_a.blank?

    self.annotations.to_a.map { |a| a['title'].downcase }.uniq
  end

  def text
    return title unless body.present?

    strip_tags(body).strip
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

  def get_annotations
    Service::Dandelion.annotations(text: self.text)
  end

  def get_sentiment
    Service::Dandelion.sentiment(text: self.text)
  end
end
