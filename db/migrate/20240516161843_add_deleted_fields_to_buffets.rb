class AddDeletedFieldsToBuffets < ActiveRecord::Migration[7.1]
  def change
    add_column :buffets, :is_enabled, :boolean, default: true
    add_column :buffets, :deleted_at, :datetime, null: true
  end
end
