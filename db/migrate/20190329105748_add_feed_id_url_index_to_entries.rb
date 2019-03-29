class AddFeedIdUrlIndexToEntries < ActiveRecord::Migration[5.2]
  def change
    add_index :entries, [:feed_id, :url], unique: true
  end
end
