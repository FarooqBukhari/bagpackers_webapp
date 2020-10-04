class HotelFacility < ApplicationRecord
  belongs_to :hotel, foreign_key: 'hotels_id'
end
