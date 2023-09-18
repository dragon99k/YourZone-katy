class CreateAddCollumnToProduct < ActiveRecord::Migration[5.2]
  def change
    create_table :add_collumn_to_products do |t|
      add_attachment :products, :image
    end
  end
end
