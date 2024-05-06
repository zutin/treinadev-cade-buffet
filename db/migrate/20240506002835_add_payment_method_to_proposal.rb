class AddPaymentMethodToProposal < ActiveRecord::Migration[7.1]
  def change
    add_column :proposals, :payment_method, :string
  end
end
