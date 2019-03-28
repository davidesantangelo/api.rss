class AddLanguageToFeeds < ActiveRecord::Migration[5.2]
  def change
    add_column :feeds, :language, :string
  end
end
