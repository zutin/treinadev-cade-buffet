class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.string :code
      t.date :desired_date
      t.integer :estimated_invitees
      t.string :observation, null: true
      t.integer :status, default: 0
      t.string :desired_address
      t.references :buffet, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end
  end
end
