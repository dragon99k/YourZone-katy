class AddDescriptionToCommunities < ActiveRecord::Migration[5.2]
  def change
    add_column :communities, :description, :text
    add_index :community_images, :deleted_at
  end
end
