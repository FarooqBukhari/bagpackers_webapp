class TourismType < ApplicationRecord
  has_many :tours
  has_many :location_tourism_types, foreign_key: 'tourism_types_id'
  has_many :locations, through: :location_tourism_types
  has_one_attached :tourism_type_picture

  def self.options_for_select
    order("LOWER(name)").map { |e| [e.name, e.id] }
  end

  validates :tourism_type_picture , presence: true

end
