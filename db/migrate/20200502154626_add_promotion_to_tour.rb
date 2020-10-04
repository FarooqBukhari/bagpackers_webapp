class AddPromotionToTour < ActiveRecord::Migration[6.0]
  def change
    add_column :tours, :promoted, :boolean, default: false
    add_column :tours, :promotion_price, :integer, default: 0
  end
end
