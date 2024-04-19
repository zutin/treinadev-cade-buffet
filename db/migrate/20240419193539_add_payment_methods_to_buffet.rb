class AddPaymentMethodsToBuffet < ActiveRecord::Migration[7.1]
  def change
    add_column :buffets, :payment_methods, :string
  end
end
