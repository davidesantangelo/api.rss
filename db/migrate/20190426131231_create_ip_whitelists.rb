class CreateIpWhitelists < ActiveRecord::Migration[5.2]
  def change
    create_table :ip_whitelists, id: :uuid do |t|
      t.string :ip_address, limit: 16
      t.timestamps
    end

    add_index :ip_whitelists, :ip_address, unique: true
  end
end