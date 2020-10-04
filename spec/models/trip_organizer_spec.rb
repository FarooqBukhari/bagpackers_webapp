require 'rails_helper'

RSpec.describe TripOrganizer, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should have_many(:tours) }
    it { should have_many(:tour_reviews).through(:tours) }
    it { should have_many(:bookings).through(:tours) }
    it { should have_many(:conversations) }
  end
end
