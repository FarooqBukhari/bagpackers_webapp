require 'rails_helper'

RSpec.describe Hotel, type: :model do
  describe "associations" do
    it { should belong_to(:hotel_manager).class_name('HotelManager').with_foreign_key(:hotel_manager_id) }
    it { should have_one(:hotel_facility) }
    it { should have_many(:hotel_reviews) }
    it { should have_many(:hotel_rooms) }
    it { should belong_to(:location).class_name('Location').with_foreign_key('locations_id') }
  end
end
