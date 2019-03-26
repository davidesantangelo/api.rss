class FeedSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :description, :url, :status
end
