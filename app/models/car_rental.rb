class CarRental < ApplicationRecord
  filterrific(
      default_filter_params: { },
      available_filters: [
          :search_query,
          :with_locations_id,
          :with_car_rental_owners,
      ],
      )

  self.per_page = 1
  scope :with_locations_id, ->(locations_ids) {
    where(location_id: [*locations_ids])
  }

  scope :with_car_rental_owners, ->(car_rental_owners){
    where(car_rental_owner_id: [*car_rental_owners])
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
          "(LOWER(hotels.name) LIKE ? OR LOWER(hotels.info) LIKE ?)"
        }.join(" AND "),
        *terms.map { |e| [e] * num_or_conds }.flatten,
        )
  }

  has_many_attached :car_rental_photos
  belongs_to :car_rental_owner , foreign_key: 'car_rental_owner_id'
  has_many :vehicles , foreign_key: 'car_rental_id' , :dependent => :delete_all
  belongs_to :location, foreign_key: "location_id"

  validates :number, numericality: true
  validates :name, presence: true
  validates :info, presence: true
  validates :address, presence: true
  validates :car_rental_photos , presence: true

end
