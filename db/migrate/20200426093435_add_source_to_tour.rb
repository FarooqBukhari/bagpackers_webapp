class AddSourceToTour < ActiveRecord::Migration[6.0]
  def change
    add_reference :tours, :source_location, foreign_key: { to_table: :locations }
  end
end
