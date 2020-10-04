class HotelManager < ApplicationRecord
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
    hotel_managers = HotelManager.find_by_sql(["SELECT hotel_managers.id from (hotel_managers INNER JOIN hotels ON hotel_managers.id = hotels.hotel_manager_id) INNER JOIN hotel_reviews ON hotels.id = hotel_reviews.hotels_id GROUP BY hotel_managers.id HAVING AVG(hotel_reviews.rating) > ?", reference_rating])
    where(id: [*hotel_managers])
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
          "(LOWER(hotel_managers.company_name) LIKE ?)"
        }.join(" AND "),
        *terms.map { |e| [e] * num_or_conds }.flatten,
        )
  }
  belongs_to :user , foreign_key: 'user_id'
  has_many :hotels , foreign_key: 'hotel_manager_id'
  has_one_attached :company_logo
  has_many :hotel_reviews, through: :hotels

  validates_uniqueness_of :user_id
  validates_presence_of :company_name
  validates_presence_of :company_logo

  def self.options_for_select
    order("LOWER(company_name)").map { |e| [e.company_name, e.id] }
  end

  def get_rating
    number_with_precision(hotel_reviews.average(:rating), precision: 2)
  end
end
