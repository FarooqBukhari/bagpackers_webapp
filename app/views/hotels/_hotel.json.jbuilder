json.extract! hotel, :id, :name, :number, :info, :address, :created_at, :updated_at
json.url hotel_url(hotel, format: :json)
