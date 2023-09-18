class AddCollumnDeletedAtToVisitsAndBlocks < ActiveRecord::Migration[5.2]
  def change
    add_column :visits, :deleted_at, :datetime, null: true
    add_column :blocks, :deleted_at, :datetime, null: true
  end
end
