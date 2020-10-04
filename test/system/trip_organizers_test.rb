require "application_system_test_case"

class TripOrganizersTest < ApplicationSystemTestCase
  setup do
    @trip_organizer = trip_organizers(:one)
  end

  test "visiting the index" do
    visit trip_organizers_url
    assert_selector "h1", text: "Trip Organizers"
  end

  test "creating a Trip organizer" do
    visit trip_organizers_url
    click_on "New Trip Organizer"

    click_on "Create Trip organizer"

    assert_text "Trip organizer was successfully created"
    click_on "Back"
  end

  test "updating a Trip organizer" do
    visit trip_organizers_url
    click_on "Edit", match: :first

    click_on "Update Trip organizer"

    assert_text "Trip organizer was successfully updated"
    click_on "Back"
  end

  test "destroying a Trip organizer" do
    visit trip_organizers_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Trip organizer was successfully destroyed"
  end
end
