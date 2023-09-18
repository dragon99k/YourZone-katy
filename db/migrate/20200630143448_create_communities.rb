class CreateCommunities < ActiveRecord::Migration[5.2]
  def change
    create_table :communities do |t|
      t.string :name, null: false, default: ""
      t.integer :category, null: false, default: 0
      t.attachment :image
      t.timestamps
    end
  end
end
