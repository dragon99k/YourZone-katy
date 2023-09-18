class CreateRateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :rate_users do |t|
      t.integer :rate_user_id, null: false, index: true
      t.integer :rate_to_user_id, null: false, index: true
      t.text :content, null: false
      t.integer :rate, null: false
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
