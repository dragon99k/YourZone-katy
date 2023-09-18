class AddCollumnStatusToFavorites < ActiveRecord::Migration[5.2]
  def change
    add_column :favorites, :status, :integer, default: 0
  end
end
