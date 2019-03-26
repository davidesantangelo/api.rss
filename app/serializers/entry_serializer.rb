class EntrySerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :body, :categories

  attribute :tags do |object|
    object.tags
  end
end
