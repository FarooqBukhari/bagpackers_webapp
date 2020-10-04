class RenameVehicleTypeColumn < ActiveRecord::Migration[6.0]
  def change
    change_table :vehicle_types do |t|
      t.rename :type, :vehicle_type
    end
  end
end
