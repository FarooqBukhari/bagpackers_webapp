require "application_system_test_case"

class CustomTripsTest < ApplicationSystemTestCase
  setup do
    @custom_trip = custom_trips(:one)
  end

  test "visiting the index" do
    visit custom_trips_url
    assert_selector "h1", text: "Custom Trips"
  end

  test "creating a Custom trip" do
    visit custom_trips_url
    click_on "New Custom Trip"

    fill_in "Childs", with: @custom_trip.childs
    fill_in "Departure city", with: @custom_trip.departure_city
    fill_in "Departure date", with: @custom_trip.departure_date
    fill_in "Number of days", with: @custom_trip.number_of_days
    fill_in "Rooms", with: @custom_trip.rooms
    fill_in "Seats", with: @custom_trip.seats
    click_on "Create Custom trip"

    assert_text "Custom trip was successfully created"
    click_on "Back"
  end

  test "updating a Custom trip" do
    visit custom_trips_url
    click_on "Edit", match: :first

    fill_in "Childs", with: @custom_trip.childs
    fill_in "Departure city", with: @custom_trip.departure_city
    fill_in "Departure date", with: @custom_trip.departure_date
    fill_in "Number of days", with: @custom_trip.number_of_days
    fill_in "Rooms", with: @custom_trip.rooms
    fill_in "Seats", with: @custom_trip.seats
    click_on "Update Custom trip"

    assert_text "Custom trip was successfully updated"
    click_on "Back"
  end

  test "destroying a Custom trip" do
    visit custom_trips_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Custom trip was successfully destroyed"
  end
end
