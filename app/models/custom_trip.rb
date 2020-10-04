class CustomTrip < ApplicationRecord
  belongs_to :user
  validates :seats, numericality: true
  validates :room, numericality: true
  validates :departure_city, presence: true
  validates :location, presence: true
  validates :description, presence: true
end
