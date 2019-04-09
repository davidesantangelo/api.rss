class TagSerializer
  include FastJsonapi::ObjectSerializer
  attributes :tags
  
  attribute :tags do |object|
    object.tags
  end
end
