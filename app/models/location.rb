class Location < ApplicationRecord
  filterrific(
      default_filter_params: { },
      available_filters: [
          :search_query,
          :with_parent_id,
          :with_tourism_types,
      ],
      )

  self.per_page = 6
  scope :with_parent_id, ->(locations_ids) {
    where(parent_id: [*locations_ids])
  }

  scope :with_tourism_types, ->(tourism_type_ids){
    where(tourism_types: [*tourism_type_ids])
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
          "(LOWER(locations.name) LIKE ?)"
        }.join(" AND "),
        *terms.map { |e| [e] * num_or_conds }.flatten,
        )
  }

  has_many_attached :images
  has_many :tours, foreign_key: "locations_id"
  has_many :tours, foreign_key: "source_location_id"
  has_many :hotels, foreign_key: "locations_id"
  has_many :location_tourism_types, foreign_key: 'locations_id'
  has_many :tourism_types, through: :location_tourism_types
  has_many :blogs, foreign_key: 'locations_id'
  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :images

  has_many :sub_locations, class_name: 'Location', foreign_key: 'parent_id'
  belongs_to :parent_location, class_name: 'Location', foreign_key: 'parent_id', optional: true

  def self.options_for_select
    order("LOWER(name)").map { |e| [e.name, e.id] }
  end

  def self.options_for_parent_select
    where(parent_id: nil).order("LOWER(name)").map { |e| [e.name, e.id] }
  end
end