class RemoveExternalIdUniqIndex < ActiveRecord::Migration[5.2]
  def change
    remove_index :entries, :external_id
    add_index :entries, :external_id
  end
end
