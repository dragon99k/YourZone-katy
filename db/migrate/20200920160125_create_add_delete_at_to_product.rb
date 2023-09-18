class CreateAddDeleteAtToProduct < ActiveRecord::Migration[5.2]
  def change
    create_table :add_delete_at_to_products do |t|
      add_column :products, :deleted_at, :datetime
      add_index :products, :deleted_at
      add_column :product_images, :deleted_at, :datetime
      add_index :product_images, :deleted_at
    end
  end
end
