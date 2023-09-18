class CreateVisits < ActiveRecord::Migration[5.2]
  def change
    create_table :visits do |t|
      t.references :user
      t.integer :visit_user_id, foreign_key: true, index: true

      t.timestamps
    end
  end
end
