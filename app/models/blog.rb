class Blog < ApplicationRecord
  filterrific(
      default_filter_params: { },
      available_filters: [
          :search_query,
          :with_locations_id,
      ],
      )

  self.per_page = 2
  scope :with_locations_id, ->(locations_ids) {
    where(locations_id: [*locations_ids])
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
          "(LOWER(blogs.title) LIKE ? OR LOWER(blogs.description) LIKE ?)"
        }.join(" AND "),
        *terms.map { |e| [e] * num_or_conds }.flatten,
        )
  }

  has_one_attached :image
  belongs_to :location, optional: true, foreign_key: "locations_id"
end
