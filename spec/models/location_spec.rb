require 'rails_helper'

RSpec.describe Location, type: :model do
  describe "associations" do
    it { should belong_to(:parent_location).optional(true) }
    it { should have_many(:location_tourism_types) }
    it { should have_many(:tours) }
    it { should have_many(:hotels) }
    it { should have_many(:blogs) }
    it { should have_many(:sub_locations) }
    it { should have_many(:tourism_types).through(:location_tourism_types) }
  end
end
