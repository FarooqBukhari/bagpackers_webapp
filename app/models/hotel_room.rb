class HotelRoom < ApplicationRecord
  belongs_to :hotel , foreign_key: 'hotels_id'
  has_many_attached :hotel_room_pictures

  validates :price, numericality: true
  validates :number_of_beds, numericality: true
  validates :room_type, presence: true
  validates :hotel_room_pictures, presence: true
end
