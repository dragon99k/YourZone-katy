class CreateLikeProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :like_products do |t|
      t.integer :user_id
      t.integer :product_id, index: true
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
