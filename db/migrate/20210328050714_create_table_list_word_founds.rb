class CreateTableListWordFounds < ActiveRecord::Migration[5.2]
  def change
    create_table :list_word_founds do |t|
      t.string :word, null: false, index: true
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
