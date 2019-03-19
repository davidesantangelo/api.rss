class CreateAuthors < ActiveRecord::Migration[5.2]
  def change
    create_table :authors, id: :uuid  do |t|
      t.string :name
      t.string :website
      t.jsonb :metadata
      t.timestamps
    end

    add_index :authors, :name
    add_index :authors, :website
  end
end
