class CreateTableReportUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :report_users do |t|
      t.integer :report_user_id, null: false, index: true
      t.integer :user_id, null: false, index: true
      t.integer :category, null: false, default: 0
      t.string :title, null: false
      t.text :content, null: false
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
