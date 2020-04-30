# frozen_string_literal: true

class AddTokenIdToFeeds < ActiveRecord::Migration[6.0]
  def change
    add_column :webhook_endpoints, :token_id, :uuid, foreign_key: true

    add_index :webhook_endpoints, :token_id
    add_index :webhook_endpoints, %i[feed_id token_id]
    add_index :webhook_endpoints, %i[feed_id token_id url], unique: true
  end
end
