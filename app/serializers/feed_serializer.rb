class FeedSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :description, :url, :status, :entries_count
end
