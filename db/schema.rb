# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_04_29_170745) do

  create_table "add_collumn_to_products", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
  end

  create_table "add_delete_at_to_products", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
  end

  create_table "admin_notifications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "title", null: false
    t.text "content", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "blocks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "block_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["block_user_id"], name: "index_blocks_on_block_user_id"
    t.index ["user_id"], name: "index_blocks_on_user_id"
  end

  create_table "chatrooms", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.integer "user1_id"
    t.integer "user2_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_chatrooms_on_deleted_at"
    t.index ["user1_id", "user2_id"], name: "index_chatrooms_on_user1_id_and_user2_id", unique: true
    t.index ["user1_id"], name: "index_chatrooms_on_user1_id"
    t.index ["user2_id"], name: "index_chatrooms_on_user2_id"
  end

  create_table "communities", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.integer "category", default: 0, null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.text "description"
    t.integer "community_user_id"
    t.integer "location"
    t.datetime "event_date"
    t.integer "remuneration", default: 0, null: false
    t.index ["community_user_id"], name: "index_communities_on_community_user_id"
    t.index ["deleted_at"], name: "index_communities_on_deleted_at"
  end

  create_table "community_images", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.bigint "community_id"
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["community_id"], name: "index_community_images_on_community_id"
    t.index ["deleted_at"], name: "index_community_images_on_deleted_at"
  end

  create_table "community_messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.integer "community_room_id"
    t.integer "user_id"
    t.text "body"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "community_notifications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.integer "community_id"
    t.integer "user_id"
    t.string "content"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "notification_type", default: 0, null: false
    t.integer "favorite_id", null: false
  end

  create_table "community_rooms", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.integer "creator_id"
    t.integer "community_topic_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["community_topic_id"], name: "index_community_rooms_on_community_topic_id"
    t.index ["creator_id"], name: "index_community_rooms_on_creator_id"
  end

  create_table "community_topic_images", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.bigint "community_topic_id"
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["community_topic_id"], name: "index_community_topic_images_on_community_topic_id"
  end

  create_table "community_topics", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.integer "community_id"
    t.integer "user_id"
    t.string "title", default: "", null: false
    t.integer "category", default: 0, null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.text "description", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["community_id"], name: "index_community_topics_on_community_id"
    t.index ["user_id"], name: "index_community_topics_on_user_id"
  end

  create_table "exchange_items", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.integer "from_user_id", null: false
    t.integer "user_id", null: false
    t.integer "product_id", null: false
    t.integer "exchange_type", default: 0
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "favorites", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "community_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.integer "status", default: 0
    t.index ["community_id"], name: "index_favorites_on_community_id"
    t.index ["deleted_at"], name: "index_favorites_on_deleted_at"
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "follows", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "follow_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_follows_on_deleted_at"
    t.index ["follow_user_id"], name: "index_follows_on_follow_user_id"
    t.index ["user_id"], name: "index_follows_on_user_id"
  end

  create_table "like_products", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.integer "user_id"
    t.integer "product_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_like_products_on_product_id"
  end

  create_table "likes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "like_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_likes_on_deleted_at"
    t.index ["like_user_id"], name: "index_likes_on_like_user_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "list_word_founds", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "word", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_list_word_founds_on_deleted_at"
    t.index ["word"], name: "index_list_word_founds_on_word"
  end

  create_table "messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.bigint "chatroom_id"
    t.bigint "user_id"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.integer "status", default: 0
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.integer "message_type", default: 0
    t.index ["chatroom_id"], name: "index_messages_on_chatroom_id"
    t.index ["deleted_at"], name: "index_messages_on_deleted_at"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "notifications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.integer "user_id", default: 0
    t.integer "like_type", default: 0
    t.integer "message_type", default: 0
    t.integer "notification_type", default: 0
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_images", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.bigint "product_id"
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_product_images_on_deleted_at"
    t.index ["product_id"], name: "index_product_images_on_product_id"
  end

  create_table "products", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "product_user_id"
    t.string "title", null: false
    t.text "description", null: false
    t.integer "residence", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "deleted_at"
    t.integer "product_type", default: 0
    t.integer "category", default: 0
    t.integer "status", default: 0
    t.string "latitude"
    t.string "longitude"
    t.index ["deleted_at"], name: "index_products_on_deleted_at"
    t.index ["product_user_id"], name: "index_products_on_product_user_id"
    t.index ["user_id"], name: "index_products_on_user_id"
  end

  create_table "rate_users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.integer "rate_user_id", null: false
    t.integer "rate_to_user_id", null: false
    t.text "content", null: false
    t.integer "rate", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_rate_users_on_deleted_at"
    t.index ["rate_to_user_id"], name: "index_rate_users_on_rate_to_user_id"
    t.index ["rate_user_id"], name: "index_rate_users_on_rate_user_id"
  end

  create_table "report_users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.integer "report_user_id", null: false
    t.integer "user_id", null: false
    t.integer "category", default: 0, null: false
    t.string "title", null: false
    t.text "content", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_report_users_on_deleted_at"
    t.index ["report_user_id"], name: "index_report_users_on_report_user_id"
    t.index ["user_id"], name: "index_report_users_on_user_id"
  end

  create_table "user_images", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.bigint "user_id"
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_user_images_on_deleted_at"
    t.index ["user_id"], name: "index_user_images_on_user_id"
  end

  create_table "user_notify_authentications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.integer "user_id"
    t.string "token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.integer "sex"
    t.string "phone_number", limit: 11
    t.integer "sms"
    t.date "birthday"
    t.integer "age_type", default: 0
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.integer "identification", default: 0
    t.string "identification_image", limit: 31
    t.text "self_introduction"
    t.string "nickname"
    t.integer "blood_type"
    t.integer "height"
    t.integer "height_type", default: 0
    t.integer "body_type", default: 0
    t.integer "birth_place", default: 0
    t.integer "academic", default: 0
    t.integer "annual_income", default: 0
    t.integer "marriage", default: 0
    t.integer "children", default: 0
    t.integer "car", default: 0
    t.integer "pet", default: 0
    t.integer "housemate", default: 0
    t.integer "alcohol", default: 0
    t.integer "favorite_eye", default: 0
    t.integer "favorite_eyebrow", default: 0
    t.integer "favorite_nose", default: 0
    t.integer "favorite_mouth", default: 0
    t.integer "favorite_hair", default: 0
    t.integer "favorite_skin", default: 0
    t.integer "favorite_charm_point", default: 0
    t.integer "feature_eye", default: 0
    t.integer "feature_eyebrow", default: 0
    t.integer "feature_nose", default: 0
    t.integer "feature_mouth", default: 0
    t.integer "feature_hair", default: 0
    t.integer "feature_skin", default: 0
    t.integer "feature_charm_point", default: 0
    t.integer "point_free", default: 20
    t.integer "point_purchased", default: 0
    t.datetime "messageable_date"
    t.string "provider"
    t.string "uid"
    t.integer "residence"
    t.integer "birthplace"
    t.integer "industry"
    t.string "nationality"
    t.string "siblings"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "deleted_at"
    t.text "interest"
    t.string "facebook_url"
    t.string "instagram_url"
    t.string "youtube_url"
    t.integer "status", default: 1
    t.integer "user_type", default: 0, null: false
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "visits", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "visit_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["user_id"], name: "index_visits_on_user_id"
    t.index ["visit_user_id"], name: "index_visits_on_visit_user_id"
  end

end
