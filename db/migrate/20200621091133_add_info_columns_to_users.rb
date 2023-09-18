class AddInfoColumnsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :residence, :integer
    add_column :users, :birthplace, :integer
    add_column :users, :industry, :integer
    add_column :users, :nationality, :string
  end
end
