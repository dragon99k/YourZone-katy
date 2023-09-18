class CreateChatrooms < ActiveRecord::Migration[5.2]
  def change
    create_table :chatrooms do |t|
      t.integer :user1_id, foreign_key: true, index: true
      t.integer :user2_id, foreign_key: true, index: true

      t.timestamps
    end

    add_index :chatrooms, [:user1_id, :user2_id], unique: true
  end
end
