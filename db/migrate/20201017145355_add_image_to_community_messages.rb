class AddImageToCommunityMessages < ActiveRecord::Migration[5.2]
  def change
    add_attachment :community_messages, :image
  end
end
