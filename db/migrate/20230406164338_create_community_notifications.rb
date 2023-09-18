class CreateCommunityNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :community_notifications do |t|
      t.integer :community_id
      t.integer :user_id
      t.string :content
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
