class AddCollumnToMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :message_type, :integer, default: 0
  end
end
