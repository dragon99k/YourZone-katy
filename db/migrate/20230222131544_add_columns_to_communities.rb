class AddColumnsToCommunities < ActiveRecord::Migration[5.2]
  def change
    add_column :communities, :location, :integer, null: true
    add_column :communities, :event_date, :datetime, null: true
  end
end
