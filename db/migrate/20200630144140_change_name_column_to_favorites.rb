class ChangeNameColumnToFavorites < ActiveRecord::Migration[5.2]
  def change
    rename_column :favorites, :favorite_user_id, :community_id
  end
end
