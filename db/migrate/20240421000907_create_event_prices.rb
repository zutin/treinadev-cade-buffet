class CreateEventPrices < ActiveRecord::Migration[7.1]
  def change
    create_table :event_prices do |t|
      t.integer :price_per_person
      t.integer :additional_person_price
      t.integer :additional_hour_price
      t.integer :weekend_price_per_person
      t.integer :weekend_additional_person_price
      t.integer :weekend_additional_hour_price
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end
  end
end
