require 'rails_helper'

RSpec.describe HotelManager, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should have_many(:hotels) }
    it { should have_many(:hotel_reviews) }
  end
end
