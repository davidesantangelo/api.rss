class Entry < ApplicationRecord
  belongs_to :feed

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
