class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.integer :user_id, default: 0
      t.integer :like_type, default: 0
      t.integer :message_type, default: 0
      t.integer :notification_type, default: 0
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
