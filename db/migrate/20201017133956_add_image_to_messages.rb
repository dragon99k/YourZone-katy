class AddImageToMessages < ActiveRecord::Migration[5.2]
  def change
    add_attachment :messages, :image
  end
end
