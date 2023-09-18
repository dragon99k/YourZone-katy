class CreateBlocks < ActiveRecord::Migration[5.2]
  def change
    create_table :blocks do |t|
      t.references :user
      t.integer :block_user_id, foreign_key: true, index: true

      t.timestamps
    end
  end
end
