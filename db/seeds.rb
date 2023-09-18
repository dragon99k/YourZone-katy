 require 'faker'
#
#
 User.destroy_all
#
# # create user
 (1..20).to_a.each do |i|
   p "user #{i}"
 
   user = User.new({
                email: email || Faker::Internet.email,
                password: password || 'password',
                name: Faker::Name.name,
                sex: [0, 1].sample,
                phone_number: Faker::PhoneNumber.cell_phone.first(11),
                birthday: Faker::Date.between(from: 20.years.ago, to: 1.years.ago),
                self_introduction: Faker::Lorem.paragraphs,
                residence: [0, 1].sample,
                birthplace: [0, 1].sample,
                industry: [0, 1].sample,
                nickname: Faker::Lorem.word,
                blood_type: [0, 2].sample,
                height: [150, 180].sample,
                height_type: 0,
                body_type: [0, 1].sample,
                birth_place: [0, 1].sample,
                academic: [0, 1].sample,
                annual_income: [0, 1].sample,
                marriage: [0, 1].sample,
                children: [0, 1].sample,
                car: [0, 1].sample,
                pet: [0, 1].sample,
                housemate: [0, 1].sample,
                alcohol: [0, 1].sample,
                favorite_eye: [0, 1].sample,
                favorite_eyebrow: [0, 1].sample,
                favorite_nose: [0, 1].sample,
                favorite_mouth: [0, 1].sample,
                favorite_hair: [0, 1].sample,
                favorite_skin: [0, 1].sample,
                favorite_charm_point: [0, 1].sample,
               feature_eye: [0, 1].sample,
                feature_eyebrow: [0, 1].sample,
                feature_nose: [0, 1].sample,
                feature_mouth: [0, 1].sample,
                feature_hair: [0, 1].sample,
                feature_skin: [0, 1].sample,
                point_free: [10, 200].sample,
                point_purchased: [10, 200].sample,
                nationality: '日本',
                siblings: Faker::Name.name,
            })
#
    profile_images = (1..5).to_a
    profile_images = profile_images.sample(1 + rand(profile_images.count))
#   #
    p "Count images #{profile_images}"
    profile_images.each do |image|
      user.user_images.build(image: File.new("#{Rails.root}/public/images/img-profile-dummy#{image}.png"))
    end
#   #
    user.image = File.new("#{Rails.root}/public/images/img-profile-dummy#{profile_images.first}.png")
#
   user.save!
 end
#
# p "create follows favorites"
 User.all.each do |user|
   p user.id

   user_ids = User.where.not(id: user.id).pluck(:id)
   follow_user_ids = user_ids.sample(1 + rand(15))
   follow_user_ids.each do |user_id|
     user.follows.create(follow_user_id: user_id)
   end
 end
#
 user_ids = User.pluck(:id)
 Community.destroy_all
 (1..20).to_a.each do |i|
   puts i
   rand_i = (1..6).sample
   Community.create!({
                     name: Faker::Name.name,
                     category: [0, 1].sample,
                     community_user_id: user_ids.sample,
                     image: File.new("#{Rails.root}/public/images/img-community#{rand_i}.png")
                 })
 end
#
 Favorite.destroy_all
#
 community_ids = Community.ids
 User.all.each do |user|
   p user.id
   ids = community_ids.sample(4 + rand(10))
   p ids
   ids.each do |community_id|
     user.favorites.create!(community_id: community_id)
   end
 end
#
 User.all.each do |user|
   p user.id
#
   user_ids = User.where.not(id: user.id).pluck(:id)
   chat_user_ids = user_ids.sample(1 + rand(2))
   chat_user_ids.each do |user_id|
     chatroom = Chatroom.new(user1_id: user.id, user2_id: user_id)
#
     (1..10).to_a.each do |i|
       chatroom.messages.build(user_id: [user.id, user_id].sample, body: Faker::Lorem.paragraph )
     end
     chatroom.save
   end
 end

User.all.each do |user|
  p user.id
  profile_images = (1..5).to_a
  profile_images = profile_images.sample(1 + rand(profile_images.count))

  p "Count images #{profile_images}"
  profile_images.each_with_index do |image, i|
    file = File.new(Rails.root.join("app/assets/images/img-profile-dummy#{image}.png"))
    if i == 0
      user.image = file
    end
    user.user_images.build(image: file)
  end
  user.save!
end
