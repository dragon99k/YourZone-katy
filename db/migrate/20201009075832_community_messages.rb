class CommunityMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :community_messages do |t|
      t.integer :community_room_id
      t.integer :user_id
      t.text :body
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
