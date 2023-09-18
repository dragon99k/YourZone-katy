class AddRemunerationToCommunities < ActiveRecord::Migration[5.2]
  def change
    add_column :communities, :remuneration, :integer, null: false, default: 0
  end
end
