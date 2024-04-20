class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.string :name
      t.string :description
      t.integer :minimum_participants
      t.integer :maximum_participants
      t.integer :default_duration
      t.string :menu
      t.boolean :alcoholic_drinks
      t.boolean :decorations
      t.boolean :valet_service
      t.references :buffet, null: false, foreign_key: true

      t.timestamps
    end
  end
end
