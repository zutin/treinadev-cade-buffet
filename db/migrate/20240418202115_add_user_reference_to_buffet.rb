class AddUserReferenceToBuffet < ActiveRecord::Migration[7.1]
  def change
    add_reference :buffets, :user, null: false, foreign_key: true
  end
end
