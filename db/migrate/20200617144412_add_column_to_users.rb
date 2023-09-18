class AddColumnToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :name, :string
    add_column :users, :sex, :integer
    add_column :users, :phone_number, :string, limit: 11
    add_column :users, :sms, :integer
    add_column :users, :birthday, :date
    add_column :users, :age_type, :integer, default: 0
    add_attachment :users, :image
    add_column :users, :identification, :integer, default: 0
    add_column :users, :identification_image, :string, limit: 31
    add_column :users, :self_introduction, :text
    add_column :users, :nickname, :string
    add_column :users, :blood_type, :integer
    add_column :users, :height, :integer
    add_column :users, :height_type, :integer, default: 0
    add_column :users, :body_type, :integer, default: 0
    add_column :users, :birth_place, :integer, default: 0
    add_column :users, :academic, :integer, default: 0
    add_column :users, :annual_income, :integer, default: 0
    add_column :users, :marriage, :integer, default: 0
    add_column :users, :children, :integer, default: 0
    add_column :users, :car, :integer, default: 0
    add_column :users, :pet, :integer, default: 0
    add_column :users, :housemate, :integer, default: 0
    add_column :users, :alcohol, :integer, default: 0
    add_column :users, :favorite_eye, :integer, default: 0
    add_column :users, :favorite_eyebrow, :integer, default: 0
    add_column :users, :favorite_nose, :integer, default: 0
    add_column :users, :favorite_mouth, :integer, default: 0
    add_column :users, :favorite_hair, :integer, default: 0
    add_column :users, :favorite_skin, :integer, default: 0
    add_column :users, :favorite_charm_point, :integer, default: 0
    add_column :users, :feature_eye, :integer, default: 0
    add_column :users, :feature_eyebrow, :integer, default: 0
    add_column :users, :feature_nose, :integer, default: 0
    add_column :users, :feature_mouth, :integer, default: 0
    add_column :users, :feature_hair, :integer, default: 0
    add_column :users, :feature_skin, :integer, default: 0
    add_column :users, :feature_charm_point, :integer, default: 0
    add_column :users, :point_free, :integer, default: 20
    add_column :users, :point_purchased, :integer, default: 0
    add_column :users, :messageable_date, :datetime
  end
end
