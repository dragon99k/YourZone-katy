class AddSiblingsColumnToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :siblings, :string
  end
end
