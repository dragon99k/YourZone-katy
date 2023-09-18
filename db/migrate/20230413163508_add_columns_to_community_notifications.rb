class AddColumnsToCommunityNotifications < ActiveRecord::Migration[5.2]
  def change
    add_column :community_notifications, :notification_type, :integer, null: false, default: 0
    add_column :community_notifications, :favorite_id, :integer, null: false
  end
end
