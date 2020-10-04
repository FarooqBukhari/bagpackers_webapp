class Tour < ApplicationRecord
  include SimpleRecommender::Recommendable
  filterrific(
      default_filter_params: { },
      available_filters: [
          :search_query,
          :with_source_location_id,
          :with_locations_id,
          :with_date_gte,
          :price_lte,
          :with_trip_organizers,
          :with_tourism_type,
          :rating_gte,
          ],
      )

  self.per_page = 6
  #filters
  scope :with_source_location_id, ->(source_location_ids){
    where(source_location_id: [*source_location_ids] )
  }
  scope :with_locations_id, ->(locations_ids) {
    where(locations_id: [*locations_ids])
  }
  scope :with_tourism_type, ->(reference_tourism_types){
    where(tourims_type_id: [*reference_tourism_types] )
  }
  scope :with_date_gte, ->(reference_time) {
    where("tours.date >= ?", reference_time)
  }
  scope :price_lte, ->(reference_price) {
    where("tours.price <= ?", reference_price)
  }
  scope :rating_gte, ->(reference_rating) {
    trip_organizers = TripOrganizer.find_by_sql(["SELECT trip_organizers.id from (trip_organizers INNER JOIN tours ON trip_organizers.id = tours.trip_organizer_id) INNER JOIN tour_reviews ON tours.id = tour_reviews.tour_id GROUP BY trip_organizers.id HAVING AVG(tour_reviews.rating) > ?", reference_rating])
    where(trip_organizer_id: [*trip_organizers])
  }
  scope :with_trip_organizers, ->(trip_organizers){
    where(trip_organizer_id: [*trip_organizers])
  }
  scope :search_query, ->(query) {
    # Searches the tours table on the 'title' and 'description' columns.
    # Matches using LIKE, automatically appends '%' to each term.
    # LIKE is case INsensitive with MySQL, however it is case
    # sensitive with PostGreSQL. To make it work in both worlds,
    # we downcase everything.
    return nil  if query.blank?

    # condition query, parse into individual keywords
    terms = query.downcase.split(/\s+/)

    # replace "*" with "%" for wildcard searches,
    # append '%', remove duplicate '%'s
    terms = terms.map { |e|
      ("%"+e.tr("*", "%") + "%").gsub(/%+/, "%")
    }
    # configure number of OR conditions for provision
    # of interpolation arguments. Adjust this if you
    # change the number of OR conditions.
    num_or_conds = 2
    where(
        terms.map { |_term|
          "(LOWER(tours.title) LIKE ? OR LOWER(tours.description) LIKE ?)"
        }.join(" AND "),
        *terms.map { |e| [e] * num_or_conds }.flatten,
        )
  }

  def self.current_tours
    Tour.where("date > ?",Date.today.to_s)
  end
  def self.past_tours
    Tour.where("date < ?", Date.today.to_s)
  end

  belongs_to :trip_organizer, foreign_key: "trip_organizer_id"
  has_many :tour_details,  dependent: :delete_all
  has_many :tour_reviews, dependent: :delete_all
  has_many :bookings, dependent: :restrict_with_error
  has_one_attached :image, dependent: :delete
  has_many :featured_tours , foreign_key: "tour_id"
  has_many_attached :trip_images, dependent: :delete_all

  has_many :users, through: :bookings
  similar_by :users

  belongs_to :tourism_type, foreign_key: "tourims_type_id"
  belongs_to :location, foreign_key: "locations_id" , class_name: "Location"
  belongs_to :source_location, class_name: "Location", foreign_key: "source_location_id"

  validates :seats, numericality: true
  validates :duration, numericality: true
  validates :price, numericality: true
  validates :title, presence: true
  validates :date , presence: true
  validates :image, presence:true

  validates :tourims_type_id, presence: true
  validates :locations_id, presence: true
  validates :source_location, presence: true

end
