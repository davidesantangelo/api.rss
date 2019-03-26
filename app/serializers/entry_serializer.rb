class EntrySerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :body, :text,  :categories

  attribute :text do |object|
    object.text
  end

  attribute :tags do |object|
    object.tags
  end
end
