require "application_system_test_case"

class HotelRoomsTest < ApplicationSystemTestCase
  setup do
    @hotel_room = hotel_rooms(:one)
  end

  test "visiting the index" do
    visit hotel_rooms_url
    assert_selector "h1", text: "Hotel Rooms"
  end

  test "creating a Hotel room" do
    visit hotel_rooms_url
    click_on "New Hotel Room"

    click_on "Create Hotel room"

    assert_text "Hotel room was successfully created"
    click_on "Back"
  end

  test "updating a Hotel room" do
    visit hotel_rooms_url
    click_on "Edit", match: :first

    click_on "Update Hotel room"

    assert_text "Hotel room was successfully updated"
    click_on "Back"
  end

  test "destroying a Hotel room" do
    visit hotel_rooms_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Hotel room was successfully destroyed"
  end
end
