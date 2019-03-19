class CreateEntries < ActiveRecord::Migration[5.2]
  def change
    create_table :entries, id: :uuid  do |t|
      t.references :feed, index: true, foreign_key: true, type: :uuid
      t.references :author, index: true, foreign_key: true, type: :uuid
      t.string :title
      t.text :body
      t.string :url
      t.string :image_url
      t.string :external_id
      t.string :categories, array: true, default: '{}'
      t.datetime :published_at
      t.timestamps
    end

    add_index :entries, :categories, using: 'gin'
    add_index :entries, :url, unique: true
    add_index :entries, :external_id, unique: true
  end
end