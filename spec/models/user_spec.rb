require 'rails_helper'

RSpec.describe User, type: :model do

  describe "associations" do
    it { should have_many(:featured_tours) }
    it { should have_many(:posts) }
    it { should have_many(:comments) }
    it { should have_many(:events) }
    it { should have_many(:custom_trips).class_name('CustomTrip').with_foreign_key('users_id') }
    it { should have_many(:bookings) }
    it { should have_many(:tours).through(:bookings) }
    it { should have_many(:tour_reviews) }
    it { should have_many(:hotel_reviews) }
    it { should have_many(:share_a_locations) }
    it { should have_one(:trip_organizer).class_name('TripOrganizer').with_foreign_key('user_id') }
    it { should have_one(:hotel_manager).class_name('HotelManager').with_foreign_key('user_id') }
    it { should have_many(:messages) }
    it { should have_many(:conversations).class_name('Conversation').with_foreign_key('sender_id') }
  end
end
