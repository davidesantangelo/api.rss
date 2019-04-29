class CreateWebhookEndpoints < ActiveRecord::Migration[5.2]
  def change
    create_table :webhook_endpoints, id: :uuid do |t|
      t.string :url, null: false
      t.string :events, null: false, array: true
      t.references :token, index: true, foreign_key: true, type: :uuid, null: false
      t.timestamps
    end

    add_index :webhook_endpoints, :url, unique: true
    add_index :webhook_endpoints, :events, using: 'gin'
  end
end
