class WebhookSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :url, :events
  belongs_to :feed
end
