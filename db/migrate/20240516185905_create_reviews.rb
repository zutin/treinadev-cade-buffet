class CreateReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :reviews do |t|
      t.integer :rating
      t.string :comment
      t.references :order, null: false, foreign_key: true
      t.references :reviewer, null: false, foreign_key: {to_table: :users}

      t.timestamps
    end
  end
end
