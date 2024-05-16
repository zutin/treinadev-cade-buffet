class AddDeletedFieldsToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :is_enabled, :boolean, default: true
    add_column :events, :deleted_at, :datetime, null: true
  end
end
