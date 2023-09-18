class CreateFollows < ActiveRecord::Migration[5.2]
  def change
    create_table :follows do |t|
      t.references :user
      t.integer :follow_user_id, foreign_key: true, index: true

      t.timestamps
    end
  end
end
