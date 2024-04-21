class ChangePricePerPersonName < ActiveRecord::Migration[7.1]
  def change
    rename_column :event_prices, :price_per_person, :base_price
    rename_column :event_prices, :weekend_price_per_person, :weekend_base_price
  end
end
