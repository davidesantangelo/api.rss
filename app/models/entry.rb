class Entry < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  def as_indexed_json(options = {})
    as_json(except: ['annotations', 'sentiment'])
  end
  
  # relations
  belongs_to :feed

  after_commit on: [:create] do
    __elasticsearch__.index_document 
  end

  after_commit on: [:update] do
    __elasticsearch__.update_document
  end

  after_commit on: [:destroy] do
    __elasticsearch__.delete_document 
  end

  def self.add(feed_id: , entry: )
    return if find_by(url: entry.url)

    attrs = {
      feed_id: feed_id,
      title: entry.title,
      body: entry.summary,
      url: entry.url,
      categories: entry.try(:categories),
      published_at: entry.published
    }

    create!(attrs)
  end

  def enrich
    self.annotations = Service::Dandelion.annotations(text: self.body)
    self.sentiment = Service::Dandelion.sentiment(text: self.body)

    save!
  end
end
