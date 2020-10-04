class LocationTourismType < ApplicationRecord
  belongs_to :location, foreign_key: 'locations_id'
  belongs_to :tourism_type, foreign_key: 'tourism_types_id'
end
