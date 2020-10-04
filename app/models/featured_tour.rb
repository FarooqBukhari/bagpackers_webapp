class FeaturedTour < ApplicationRecord
  belongs_to :tour, foreign_key: "tour_id", optional: true
  belongs_to :hotel, foreign_key: "hotels_id", optional: true
  belongs_to :user, foreign_key: "user_id"
end
