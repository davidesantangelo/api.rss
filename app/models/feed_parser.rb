# frozen_string_literal: true

class FeedParser
  def self.entries(url:, from: nil)
    results = begin
                Feed.parse(url: url).entries
              rescue StandardError
                []
              end

    if from.present?
      results.select do |entry|
        entry.published.to_i >= from.to_i
      end
    end

    results
  end
end
