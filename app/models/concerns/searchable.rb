# frozen_string_literal: true

module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    after_commit(
      -> { __elasticsearch__.index_document },
      on: %i[create update]
    )

    after_commit(
      -> { __elasticsearch__.delete_document },
      on: :destroy
    )

    index_name do
      [
        Rails.application.engine_name,
        elasticsearch_index_name.to_s.underscore.gsub(%r{/}, '-'),
        ::Rails.env
      ].join('_')
    end
  end

  module ClassMethods
    def elasticsearch_index_name
      name
    end
  end
end
