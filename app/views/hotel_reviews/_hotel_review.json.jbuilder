json.extract! hotel_review, :id, :created_at, :updated_at
json.url hotel_review_url(hotel_review, format: :json)
