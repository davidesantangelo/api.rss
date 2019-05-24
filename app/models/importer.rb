class Importer
  def self.run(limit: 1000)
    Feed.unscoped.all.order("last_import_at ASC NULLS FIRST").limit(limit).find_each do |feed|
      feed.async_update
    end
  end

  def self.reload(feed:)
    feed.entries.delete_all
    feed.logs.delete_all
    feed.async_import
  end

  module ElasticSearch
    def self.reset_index(model:)
      model.__elasticsearch__.create_index!(force: true)
      model.__elasticsearch__.refresh_index!
    end
  end
end
