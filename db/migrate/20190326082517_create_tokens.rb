class CreateTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :tokens, id: :uuid  do |t|
      t.string :key
      t.datetime :expires_at
      t.boolean :active, default: true
      t.timestamps
    end

    add_index :tokens, :key, unique: true
  end
end
