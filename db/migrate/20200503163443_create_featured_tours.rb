class CreateFeaturedTours < ActiveRecord::Migration[6.0]
  def change
    create_table :featured_tours do |t|
      t.bigint "tour_id"
      t.bigint "user_id"
      t.integer "duration" , default: 1
      t.integer "payment_amount" , default: 0
      t.boolean "payment_status" , default: false
      t.index ["user_id"], name: "index_featured_tours_on_user_id"
      t.index ["tour_id"], name: "index_featured_tours_on_tour_id"
    end
    add_foreign_key "featured_tours", "users"
    add_foreign_key "featured_tours", "tours"
  end
end
