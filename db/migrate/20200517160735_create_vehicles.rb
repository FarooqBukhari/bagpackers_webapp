class CreateVehicles < ActiveRecord::Migration[6.0]
  def self.up
    create_table :vehicles do |t|
      t.integer "car_rental_id", null: false
      t.string "vehicle_type", null: false
      t.integer "capacity", default: 1, null: false
      t.integer "rent_with_driver", default: 0, null: false
      t.integer "rent_self", default: 0, null: false
      t.string "company_model", null: false
      t.string "make_year", null: false
      t.index ["car_rental_id"], name: "index_vehicles_on_car_rentals_id"
      t.timestamps
    end
    create_table :vehicle_types do |t|
      t.string "type"
    end
  end
  def self.down
    drop_table :vehicles
    drop_table :vehicle_types
  end
end
