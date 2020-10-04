json.extract! custom_trip, :id, :seats, :childs, :rooms, :departure_city, :departure_date, :number_of_days, :created_at, :updated_at
json.url custom_trip_url(custom_trip, format: :json)
