class AddCanChangeLocationToEvent < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :can_change_location, :boolean
  end
end
