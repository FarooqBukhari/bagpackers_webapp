class AddIsCarRentalOwnerToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, "is_car_rental_owner", :boolean, default: false
  end
end
