class CreateCustomTrips < ActiveRecord::Migration[6.0]
  def change
    create_table :custom_trips do |t|
      t.integer "seats"
      t.integer "child"
      t.integer "room"
      t.string "departure_city"
      t.date "departure_date"
      t.time "departure_time"
      t.integer "number_of_days"
      t.string "location"
      t.text "description"
      t.belongs_to :tourism_types
      t.belongs_to :users

      t.index ["users_id"], name: "index_custom_trip_on_users_id"
      t.timestamps
    end
  end
end
