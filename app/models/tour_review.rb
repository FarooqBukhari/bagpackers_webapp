class TourReview < ApplicationRecord
  belongs_to :tour
  belongs_to :user

  validates_presence_of :review_text
  validates_numericality_of :rating

  validates_uniqueness_of :user_id, scope: :tour_id

end
