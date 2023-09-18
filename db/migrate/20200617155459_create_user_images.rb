class CreateUserImages < ActiveRecord::Migration[5.2]
  def change
    create_table :user_images do |t|
      t.references :user
      t.attachment :image

      t.timestamps
    end
  end
end
