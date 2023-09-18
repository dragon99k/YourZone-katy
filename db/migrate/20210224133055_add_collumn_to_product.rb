class AddCollumnToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :latitude, :string, null: true
    add_column :products, :longitude, :string, null: true
  end
end
