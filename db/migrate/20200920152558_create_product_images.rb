class CreateProductImages < ActiveRecord::Migration[5.2]
  def change
    create_table :product_images do |t|
      t.references :product
      t.attachment :image

      t.timestamps
    end
  end
end
