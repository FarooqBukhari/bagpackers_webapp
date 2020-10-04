class AddHotelToFeaturedTour < ActiveRecord::Migration[6.0]
  def change
    add_reference :featured_tours, :hotels, foreign_key: true
    add_column :featured_tours, :featured_type, :text
  end
end
