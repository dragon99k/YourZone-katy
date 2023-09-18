class ChangeCollumnCommunityRooms < ActiveRecord::Migration[5.2]
  def change
    rename_column :community_rooms, :community_id, :community_topic_id
  end
end
