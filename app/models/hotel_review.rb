class HotelReview < ApplicationRecord
  belongs_to :user
  belongs_to :hotel, foreign_key: 'hotels_id'

  validates_presence_of :review_text
  validates_numericality_of :rating

  validates_uniqueness_of :user_id, scope: :hotels_id
end
