class CreateCarRentals < ActiveRecord::Migration[6.0]
  def change
    create_table :car_rentals do |t|
      t.string "name"
      t.string "info"
      t.string "number"
      t.string "address"
      t.string "email"
      t.text "website_url"
      t.bigint "car_rental_owner_id", null: false
      t.bigint "location_id"
      t.index ["car_rental_owner_id"], name: "index_car_rentals_on_car_rental_owner_id"
      t.index ["location_id"], name: "index_car_rentals_on_location_id"
      t.timestamps
    end
    add_foreign_key "car_rentals", "car_rental_owners"
    add_foreign_key "car_rentals", "locations"
  end
end
