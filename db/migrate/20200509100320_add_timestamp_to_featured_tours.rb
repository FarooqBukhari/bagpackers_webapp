class AddTimestampToFeaturedTours < ActiveRecord::Migration[6.0]
  def change
    add_timestamps :featured_tours, null: false, default: -> { 'NOW()' }
  end
end
