class CreateChatMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :chat_messages do |t|
      t.string :text
      t.integer :status, default: 0
      t.references :sender, null: false, foreign_key: {to_table: :users}
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
