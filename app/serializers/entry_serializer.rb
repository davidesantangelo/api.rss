class EntrySerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :url, :published_at, :body, :text, :categories, :sentiment
  belongs_to :feed
  
  attribute :text do |object|
    object.text
  end

  attribute :tags do |object|
    object.tags
  end

  attribute :published_at do |object|
    object.published_at.to_i
  end
end
