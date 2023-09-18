class CommunityTopicImages < ActiveRecord::Migration[5.2]
  def change
    create_table :community_topic_images do |t|
      t.references :community_topic
      t.attachment :image
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
