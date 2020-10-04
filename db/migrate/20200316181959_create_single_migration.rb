class CreateSingleMigration < ActiveRecord::Migration[6.0]
  def change
    create_table "users", force: :cascade do |t|
      t.string "email", default: "", null: false
      t.string "encrypted_password", default: "", null: false
      t.string "name", default: "", null: false
      t.string "about"
      t.string "reset_password_token"
      t.datetime "reset_password_sent_at"
      t.datetime "remember_created_at"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.string "sex", default: "male", null: false
      t.string "location"
      t.date "dob"
      t.string "phone_number"
      t.integer "posts_count", default: 0, null: false
      t.string "slug"
      t.boolean "is_admin"
      t.boolean "is_trip_organizer"
      t.boolean "is_hotel_manager"
      t.string "authentication_token"
      t.string "stripe_id"
      t.index ["authentication_token"], name: "index_users_on_authentication_token"
      t.index ["email"], name: "index_users_on_email", unique: true
      t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
      t.index ["slug"], name: "index_users_on_slug", unique: true
    end

    create_table "votes", force: :cascade do |t|
      t.string "votable_type"
      t.integer "votable_id"
      t.string "voter_type"
      t.integer "voter_id"
      t.boolean "vote_flag"
      t.string "vote_scope"
      t.integer "vote_weight"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.index ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope"
      t.index ["votable_type", "votable_id"], name: "index_votes_on_votable_type_and_votable_id"
      t.index ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope"
      t.index ["voter_type", "voter_id"], name: "index_votes_on_voter_type_and_voter_id"
    end

    create_table "trip_organizers", force: :cascade do |t|
      t.string "company_name"
      t.string "address"
      t.text "about"
      t.text "cancellation_policy"
      t.string "url"
      t.boolean "is_approved"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.integer "user_id"
      t.string "company_email"
      t.string "company_number"
      t.text "terms"
      t.index ["user_id"], name: "index_trip_organizers_on_user_id"
    end

    create_table "hotel_managers", force: :cascade do |t|
      t.integer "user_id", null: false
      t.string "company_name"
      t.boolean "is_approved"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.index ["user_id"], name: "index_hotel_managers_on_user_id"
    end

    create_table "geocodes", force: :cascade do |t|
      t.string "name"
      t.integer "geocode"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
    end

    create_table "locations", force: :cascade do |t|
      t.text "description"
      t.string "name"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
    end

    create_table "tourism_types", force: :cascade do |t|
      t.string "name"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
    end

    create_table "tours", force: :cascade do |t|
      t.string "title"
      t.integer "price"
      t.date "date"
      t.integer "duration"
      t.integer "seats"
      t.text "description"
      t.text "services_included"
      t.text "services_not_included"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.integer "trip_organizer_id"
      t.bigint "tourims_type_id"
      t.bigint "locations_id"
      t.index ["locations_id"], name: "index_tours_on_locations_id"
      t.index ["tourims_type_id"], name: "index_tours_on_tourims_type_id"
      t.index ["trip_organizer_id"], name: "index_tours_on_trip_organizer_id"
    end

    create_table "hotels", force: :cascade do |t|
      t.string "name"
      t.string "rate"
      t.string "info"
      t.string "number"
      t.string "address"
      t.string "email"
      t.text "website_url"
      t.integer "hotel_manager_id", null: false
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.bigint "locations_id"
      t.index ["hotel_manager_id"], name: "index_hotels_on_hotel_manager_id"
      t.index ["locations_id"], name: "index_hotels_on_locations_id"
    end

    create_table "hotel_facility_names", force: :cascade do |t|
      t.string "name"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
    end

    create_table "active_storage_blobs", force: :cascade do |t|
      t.string "key", null: false
      t.string "filename", null: false
      t.string "content_type"
      t.text "metadata"
      t.bigint "byte_size", null: false
      t.string "checksum", null: false
      t.datetime "created_at", null: false
      t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
    end

    create_table "active_storage_attachments", force: :cascade do |t|
      t.string "name", null: false
      t.string "record_type", null: false
      t.integer "record_id", null: false
      t.integer "blob_id", null: false
      t.datetime "created_at", null: false
      t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
      t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
    end

    create_table "activities", force: :cascade do |t|
      t.string "trackable_type"
      t.integer "trackable_id"
      t.string "owner_type"
      t.integer "owner_id"
      t.string "key"
      t.text "parameters"
      t.string "recipient_type"
      t.integer "recipient_id"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.index ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type"
      t.index ["owner_type", "owner_id"], name: "index_activities_on_owner_type_and_owner_id"
      t.index ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type"
      t.index ["recipient_type", "recipient_id"], name: "index_activities_on_recipient_type_and_recipient_id"
      t.index ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type"
      t.index ["trackable_type", "trackable_id"], name: "index_activities_on_trackable_type_and_trackable_id"
    end

    create_table "bookings", force: :cascade do |t|
      t.integer "user_id", null: false
      t.integer "tour_id", null: false
      t.integer "no_of_seats"
      t.boolean "payment_status"
      t.integer "payment_amount"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.index ["tour_id"], name: "index_bookings_on_tour_id"
      t.index ["user_id"], name: "index_bookings_on_user_id"
    end

    create_table "comments", force: :cascade do |t|
      t.string "title", limit: 50, default: ""
      t.text "comment"
      t.string "commentable_type"
      t.integer "commentable_id"
      t.integer "user_id"
      t.string "role", default: "comments"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.text "comment_html"
      t.index ["commentable_id"], name: "index_comments_on_commentable_id"
      t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id"
      t.index ["commentable_type"], name: "index_comments_on_commentable_type"
      t.index ["user_id"], name: "index_comments_on_user_id"
    end

    create_table "custom_requests", force: :cascade do |t|
      t.integer "user_id", null: false
      t.string "location"
      t.text "description"
      t.integer "seats"
      t.date "date"
      t.integer "duration"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.index ["user_id"], name: "index_custom_requests_on_user_id"
    end

    create_table "events", force: :cascade do |t|
      t.string "name"
      t.datetime "when"
      t.integer "user_id"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.integer "cached_votes_up", default: 0
      t.integer "comments_count", default: 0
      t.index ["cached_votes_up"], name: "index_events_on_cached_votes_up"
      t.index ["comments_count"], name: "index_events_on_comments_count"
      t.index ["user_id"], name: "index_events_on_user_id"
    end

    create_table "follows", force: :cascade do |t|
      t.string "followable_type", null: false
      t.integer "followable_id", null: false
      t.string "follower_type", null: false
      t.integer "follower_id", null: false
      t.boolean "blocked", default: false, null: false
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.index ["followable_id", "followable_type"], name: "fk_followables"
      t.index ["followable_type", "followable_id"], name: "index_follows_on_followable_type_and_followable_id"
      t.index ["follower_id", "follower_type"], name: "fk_follows"
      t.index ["follower_type", "follower_id"], name: "index_follows_on_follower_type_and_follower_id"
    end

    create_table "friendly_id_slugs", force: :cascade do |t|
      t.string "slug", null: false
      t.integer "sluggable_id", null: false
      t.string "sluggable_type", limit: 50
      t.string "scope"
      t.datetime "created_at"
      t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
      t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
      t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
      t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
    end

    create_table "hotel_facilities", force: :cascade do |t|
      t.boolean "parking", default: false
      t.boolean "wifi", default: false
      t.boolean "pool", default: false
      t.boolean "playground", default: false
      t.boolean "mess", default: false
      t.boolean "shop", default: false
      t.boolean "laundary", default: false
      t.boolean "gym", default: false
      t.boolean "room_service", default: false
      t.boolean "hot_water", default: false
      t.boolean "camera", default: false
      t.boolean "ups", default: false
      t.integer "hotels_id", null: false
      t.index ["hotels_id"], name: "index_hotel_facilities_on_hotels_id"
    end

    create_table "hotel_reviews", force: :cascade do |t|
      t.integer "user_id", null: false
      t.text "review_text"
      t.integer "rating"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.bigint "hotels_id"
      t.index ["hotels_id"], name: "index_hotel_reviews_on_hotels_id"
      t.index ["user_id"], name: "index_hotel_reviews_on_user_id"
    end

    create_table "hotel_rooms", force: :cascade do |t|
      t.integer "hotels_id", null: false
      t.string "room_type"
      t.integer "number_of_beds", default: 1, null: false
      t.boolean "heater", default: false
      t.boolean "air_conditioned", default: false
      t.boolean "tv", default: false
      t.boolean "kitchenette", default: false
      t.boolean "refrigerator", default: false
      t.boolean "microwave", default: false
      t.integer "price", default: 0, null: false
      t.index ["hotels_id"], name: "index_hotel_rooms_on_hotels_id"
    end

    create_table "hotel_room_facilities", force: :cascade do |t|
      t.string "name"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
    end

    create_table "posts", force: :cascade do |t|
      t.text "content", null: false
      t.integer "user_id"
      t.string "attachment"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.integer "cached_votes_up", default: 0
      t.integer "comments_count", default: 0
      t.text "content_html"
      t.index ["cached_votes_up"], name: "index_posts_on_cached_votes_up"
      t.index ["comments_count"], name: "index_posts_on_comments_count"
      t.index ["user_id"], name: "index_posts_on_user_id"
    end

    create_table "share_a_locations", force: :cascade do |t|
      t.text "description"
      t.integer "user_id", null: false
      t.string "location_name"
      t.string "address"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.index ["user_id"], name: "index_share_a_locations_on_user_id"
    end

    create_table "tour_details", force: :cascade do |t|
      t.integer "tour_id"
      t.integer "day"
      t.string "location"
      t.text "description"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.index ["tour_id"], name: "index_tour_details_on_tour_id"
    end

    create_table "tour_reviews", force: :cascade do |t|
      t.integer "tour_id", null: false
      t.integer "user_id", null: false
      t.integer "rating"
      t.text "review_text"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.index ["tour_id"], name: "index_tour_reviews_on_tour_id"
      t.index ["user_id"], name: "index_tour_reviews_on_user_id"
    end

    add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
    add_foreign_key "bookings", "tours"
    add_foreign_key "bookings", "users"
    add_foreign_key "custom_requests", "users"
    add_foreign_key "hotel_facilities", "hotels", column: "hotels_id"
    add_foreign_key "hotel_managers", "users"
    add_foreign_key "hotel_reviews", "users"
    add_foreign_key "hotel_reviews", "hotels", column: "hotels_id"
    add_foreign_key "hotel_rooms", "hotels", column: "hotels_id"
    add_foreign_key "hotels", "hotel_managers"
    add_foreign_key "share_a_locations", "users"
    add_foreign_key "tour_reviews", "tours"
    add_foreign_key "tour_reviews", "users"
    add_foreign_key "tours", "trip_organizers"
    add_foreign_key "trip_organizers", "users"
  end
end
