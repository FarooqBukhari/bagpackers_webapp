class Hotel < ApplicationRecord
  filterrific(
      default_filter_params: { },
      available_filters: [
          :search_query,
          :with_locations_id,
          :price_lte,
          :with_hotel_managers,
          :rating_gte,
      ],
      )

  self.per_page = 2
  scope :with_locations_id, ->(locations_ids) {
    where(locations_id: [*locations_ids])
  }
  scope :price_lte, ->(reference_price) {
    hotels = Hotel.all
    hotels_filtered = []
    hotels.each do |hotel|
      rate = hotel.rate
      if !(rate.nil?)
        rate = rate.split("-")
        if rate[-1].to_i <= reference_price || rate[0].to_i <= reference_price
          hotels_filtered.push(hotel.id)
        end
      end
    end
    where(id: [*hotels_filtered])
  }
  scope :rating_gte, ->(reference_rating) {
    hotel_managers = HotelManager.find_by_sql(["SELECT hotel_managers.id from (hotel_managers INNER JOIN hotels ON hotel_managers.id = hotels.hotel_manager_id) INNER JOIN hotel_reviews ON hotels.id = hotel_reviews.hotels_id GROUP BY hotel_managers.id HAVING AVG(hotel_reviews.rating) > ?", reference_rating])
    where(hotel_manager_id: [*hotel_managers])
  }
  scope :with_hotel_managers, ->(hotel_managers){
    where(hotel_manager_id: [*hotel_managers])
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

  has_many_attached :hotel_cover_photos
  has_one_attached :proof_of_ownership
  belongs_to :hotel_manager , foreign_key: 'hotel_manager_id'
  has_many :hotel_reviews, foreign_key: 'hotels_id' , :dependent => :delete_all
  has_one :hotel_facility, foreign_key: 'hotels_id' , :dependent => :destroy
  has_many :hotel_rooms , foreign_key: 'hotels_id' , :dependent => :delete_all
  belongs_to :location, foreign_key: "locations_id"

  validates :number, numericality: true
  validates :name, presence: true
  validates :info, presence: true
  validates :address, presence: true
  validates :hotel_cover_photos, presence: true

  validates_presence_of :proof_of_ownership

end
