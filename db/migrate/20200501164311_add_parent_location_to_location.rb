class AddParentLocationToLocation < ActiveRecord::Migration[6.0]
  def change
    add_column :locations, :parent_id, :integer
    add_index :locations, :parent_id
  end
end
