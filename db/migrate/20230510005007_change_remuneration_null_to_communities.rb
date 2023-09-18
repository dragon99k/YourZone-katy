class ChangeRemunerationNullToCommunities < ActiveRecord::Migration[5.2]
  def change
    change_column_null :communities, :remuneration, true
  end
end
