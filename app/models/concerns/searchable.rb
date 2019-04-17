module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    after_commit(
      lambda { __elasticsearch__.index_document  },
      on: [:create, :update],
    )

    after_commit(
      lambda { __elasticsearch__.delete_document },
      on: :destroy,
    )

    index_name do
      [
        Rails.application.engine_name,
        self.elasticsearch_index_name.to_s.underscore.gsub(/\//, '-'),
        ::Rails.env,
      ].join('_')
    end
  end

  module ClassMethods
    def elasticsearch_index_name
      name
    end
  end
end
