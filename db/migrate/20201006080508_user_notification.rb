class UserNotification < ActiveRecord::Migration[5.2]
  def change
    create_table :user_notify_authentications do |t|
      t.integer :user_id
      t.string :token, null: false

      t.timestamps null: false
    end
  end
end
