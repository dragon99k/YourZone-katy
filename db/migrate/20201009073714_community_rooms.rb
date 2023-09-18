class CommunityRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :community_rooms do |t|
      t.integer :creator_id, foreign_key: true, index: true
      t.integer :community_id, index: true
      t.datetime :deleted_at, null: true

      t.timestamps
    end
  end
end
