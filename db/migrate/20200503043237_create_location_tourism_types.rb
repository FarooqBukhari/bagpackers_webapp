class CreateLocationTourismTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :location_tourism_types do |t|
      t.belongs_to :locations
      t.belongs_to :tourism_types
      t.timestamps
    end
  end
end
