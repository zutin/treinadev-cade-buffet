class CreateBuffets < ActiveRecord::Migration[7.1]
  def change
    create_table :buffets do |t|
      t.string :trading_name
      t.string :company_name
      t.string :registration_number
      t.string :contact_number
      t.string :email
      t.string :address
      t.string :district
      t.string :state
      t.string :city
      t.string :zipcode
      t.string :description

      t.timestamps
    end
  end
end
