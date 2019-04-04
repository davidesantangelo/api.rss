FactoryBot.define do
  factory :token do
    id { SecureRandom.uuid }
    title { 'feed RSS title' }
    description { 'feed RSS description '}
    url { 'http://url/rss2.0.xml' }
  end
end
