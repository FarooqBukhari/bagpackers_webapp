class CreateCarRentalOwners < ActiveRecord::Migration[6.0]
  def change
    create_table :car_rental_owners do |t|
      t.integer "user_id", null: false
      t.string "company_name"
      t.boolean "is_approved"
      t.index ["user_id"], name: "index_car_rental_owners_on_user_id"
      t.timestamps
    end
    add_foreign_key "car_rental_owners", "users"
  end
end
