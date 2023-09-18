class CommunityTopic < ActiveRecord::Migration[5.2]
  def change
    create_table :community_topics do |t|
      t.integer :community_id, index: true
      t.integer :user_id, index: true
      t.string :title, null: false, default: ""
      t.integer :category, null: false, default: 0
      t.attachment :image
      t.text :description, null: false
      t.datetime :deleted_at, null: true

      t.timestamps
    end
  end
end
