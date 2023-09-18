class AddColumnsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :user_type, :integer, null: false, default: 0
  end
end
