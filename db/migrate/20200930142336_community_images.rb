class CommunityImages < ActiveRecord::Migration[5.2]
  def change
    create_table :community_images do |t|
      t.references :community
      t.attachment :image
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
