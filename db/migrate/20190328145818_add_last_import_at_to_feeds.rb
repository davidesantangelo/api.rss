class AddLastImportAtToFeeds < ActiveRecord::Migration[5.2]
  def change
    add_column :feeds, :last_import_at, :datetime
  end
end
