class Entry < ApplicationRecord
  belongs_to :feed
  belongs_to :author

  def self.add(feed_id: , entry: )
    return if find_by(url: entry.url)

    author = Author.find_or_create_by(name: Feed.author_name(entry: entry))

    create!(
      feed_id: feed_id,
      author_id: author.id,
      title: entry.title,
      body: entry.summary,
      url: entry.url,
      categories: entry.try(:categories),
      published_at: entry.published
    )
  end
end
