class CreateProposals < ActiveRecord::Migration[7.1]
  def change
    create_table :proposals do |t|
      t.integer :total_value
      t.date :expire_date
      t.string :description, null: true
      t.integer :discount, null: true
      t.integer :tax, null: true
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
