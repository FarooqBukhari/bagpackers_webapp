class CarRentalOwner < ApplicationRecord
  filterrific(
      default_filter_params: { },
      available_filters: [
          :search_query,
      ],
      )

  self.per_page = 1

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
          "(LOWER(car_rental_owners.company_name) LIKE ?)"
        }.join(" AND "),
        *terms.map { |e| [e] * num_or_conds }.flatten,
        )
  }

  belongs_to :user, foreign_key: "user_id"
  has_many :car_rentals, foreign_key: "car_rental_owner_id"
  has_one_attached :company_logo

  validates_uniqueness_of :user_id
  validates_presence_of :company_name
  validates_presence_of :company_logo

  def self.options_for_select
    order("LOWER(company_name)").map { |e| [e.company_name, e.id] }
  end
end
