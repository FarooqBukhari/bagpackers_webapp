class Vehicle < ApplicationRecord
  filterrific(
      default_filter_params: { },
      available_filters: [
          :price_lte,
          :with_car_company,
          :capacity_gte
      ],
      )

  self.per_page = 1
  scope :capacity_gte, ->(capacity) {
    where("vehicles.capacity >= ?", capacity)
  }
  scope :price_lte, ->(reference_price) {
    where("vehicles.rent_self <= ? OR vehicles.rent_with_driver <= ?", reference_price,reference_price)
  }
  scope :with_car_company, ->(reference_company_make) {
    where("(LOWER(vehicles.company_model) LIKE ? OR LOWER(vehicles.make_year) LIKE ?)", reference_company_make,reference_company_make)
  }

  belongs_to :car_rental , foreign_key: 'car_rental_id'
  has_many_attached :vehicle_pictures

  validates :rent_self, numericality: true
  validates :rent_with_driver, numericality: true
  validates :capacity, numericality: true
  validates :vehicle_type, presence: true
  validates :vehicle_pictures, presence: true
  validates :company_model, presence: true
  validates :make_year, presence: true

end
