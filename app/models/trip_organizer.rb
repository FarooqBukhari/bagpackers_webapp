class TripOrganizer < ApplicationRecord
  include ActionView::Helpers::NumberHelper
  filterrific(
      default_filter_params: { },
      available_filters: [
          :search_query,
          :rating_gte,
      ],
      )

  self.per_page = 6


  scope :rating_gte, ->(reference_rating) {
    trip_organizers = TripOrganizer.find_by_sql(["SELECT trip_organizers.id from (trip_organizers INNER JOIN tours ON trip_organizers.id = tours.trip_organizer_id) INNER JOIN tour_reviews ON tours.id = tour_reviews.tour_id GROUP BY trip_organizers.id HAVING AVG(tour_reviews.rating) > ?", reference_rating])
    where(id: [*trip_organizers])
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
    num_or_conds = 1
    where(
        terms.map { |_term|
          "(LOWER(trip_organizers.company_name) LIKE ?)"
        }.join(" AND "),
        *terms.map { |e| [e] * num_or_conds }.flatten,
        )
  }
  has_one_attached :license
  has_one_attached :company_logo
  belongs_to :user
  has_many :tours, foreign_key: "trip_organizer_id"
  has_many :tour_reviews, through: :tours
  has_many :bookings, through: :tours
  has_many :conversations, foreign_key: :recipient_id


  validates_uniqueness_of :user_id
  validates_presence_of :company_name
  validates_presence_of :company_number
  validates :company_email , format: { with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
                               message: "Not a valid Email" }
  validates_presence_of :address
  validates_presence_of :about
  validates_presence_of :terms
  validates_presence_of :company_logo
  validates_presence_of :license
  validates_presence_of :cancellation_policy
  validates_presence_of :url

  def self.options_for_select
    order("LOWER(company_name)").map { |e| [e.company_name, e.id] }
  end

  def get_rating
    number_with_precision(tour_reviews.average(:rating), precision: 2)
  end

end