class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.references :user
      t.integer :product_user_id, foreign_key: true, index: true
      t.string :title, null: false
      t.text :description, null: false
      t.integer :residence, null: false, default: 1

      t.timestamps
    end
  end
end
