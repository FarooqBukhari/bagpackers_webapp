class AddNumberOfBedsToHotelRoom < ActiveRecord::Migration[6.0]
  def change
    add_column :hotel_rooms, :number_of_beds, :integer , :default => 1
  end
end
