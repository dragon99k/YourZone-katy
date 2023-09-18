class AddTypeColumnToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :type, :string, null: true
  end
end
