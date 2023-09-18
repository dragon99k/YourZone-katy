class CreateLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :likes do |t|
      t.references :user
      t.integer :like_user_id, foreign_key: true, index: true

      t.timestamps
    end
  end
end
