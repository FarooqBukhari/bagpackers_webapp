require 'rails_helper'

RSpec.describe Tour, type: :model do
  describe "associations" do
    it { should belong_to(:trip_organizer).class_name('TripOrganizer').with_foreign_key(:trip_organizer_id) }
    it { should have_many(:tour_details) }
    it { should have_many(:tour_reviews) }
    it { should have_many(:bookings) }
    it { should have_many(:featured_tours).class_name('FeaturedTour').with_foreign_key(:tour_id) }
    it { should have_many(:users).through(:bookings) }
    it { should belong_to(:tourism_type).class_name('TourismType').with_foreign_key('tourims_type_id') }
    it { should belong_to(:location).class_name('Location').with_foreign_key('locations_id') }
    it { should belong_to(:source_location).class_name('Location').with_foreign_key('source_location_id') }
  end
end
