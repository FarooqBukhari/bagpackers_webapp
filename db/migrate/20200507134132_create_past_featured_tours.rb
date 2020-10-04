class CreatePastFeaturedTours < ActiveRecord::Migration[6.0]
  def change
    create_table :past_featured_tours do |t|
      t.bigint "tour_id"
      t.bigint "user_id"
      t.integer "duration", default: 1
      t.integer "payment_amount", default: 0
      t.boolean "payment_status", default: false
      t.bigint "hotels_id"
      t.text "featured_type"
      t.date "requested_at"
      t.index ["hotels_id"], name: "past_index_featured_tours_on_hotels_id"
      t.index ["tour_id"], name: "past_index_featured_tours_on_tour_id"
      t.index ["user_id"], name: "past_index_featured_tours_on_user_id"
      t.timestamps
    end
    add_foreign_key "past_featured_tours", "hotels", column: "hotels_id"
    add_foreign_key "past_featured_tours", "tours"
    add_foreign_key "past_featured_tours", "users"
    end
  end
