class AddUserIdToCommunities < ActiveRecord::Migration[5.2]
  def change
    add_column :communities, :community_user_id, :integer
    add_index :communities, :community_user_id
  end
end
