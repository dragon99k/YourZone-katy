
desc "fake users"
task "user:master_data" => :environment do
  (1..99).to_a.each do |i|
    User.create(password: "123456789", email: "user_name_#{i}@gmail.com", name: "user name #{i}", sex: 1,
      phone_number: "0336896191", birthday: "1996/10/10", nickname: "user_name_#{i}", confirmed_at: Time.zone.now)
  end
end
