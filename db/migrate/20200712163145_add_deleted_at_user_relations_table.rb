class AddDeletedAtUserRelationsTable < ActiveRecord::Migration[5.2]
  def change
    add_column :user_images, :deleted_at, :datetime
    add_index :user_images, :deleted_at
    add_column :likes, :deleted_at, :datetime
    add_index :likes, :deleted_at
    add_column :messages, :deleted_at, :datetime
    add_index :messages, :deleted_at
    add_column :follows, :deleted_at, :datetime
    add_index :follows, :deleted_at
    add_column :favorites, :deleted_at, :datetime
    add_index :favorites, :deleted_at
    add_column :communities, :deleted_at, :datetime
    add_index :communities, :deleted_at
    add_column :chatrooms, :deleted_at, :datetime
    add_index :chatrooms, :deleted_at
  end
end
