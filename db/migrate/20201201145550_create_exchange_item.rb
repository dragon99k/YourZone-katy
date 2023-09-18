class CreateExchangeItem < ActiveRecord::Migration[5.2]
  def change
    create_table :exchange_items do |t|
      t.integer :from_user_id, null: false
      t.integer :user_id, null: false
      t.integer :product_id, null: false
      t.integer :exchange_type, default: 0
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
