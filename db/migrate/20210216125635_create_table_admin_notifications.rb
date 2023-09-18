class CreateTableAdminNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :admin_notifications do |t|
        t.string :title, null: false
        t.text :content, null: false
        t.datetime :deleted_at

        t.timestamps
    end
  end
end
