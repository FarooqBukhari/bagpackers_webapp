require "application_system_test_case"

class HotelManagersTest < ApplicationSystemTestCase
  setup do
    @hotel_manager = hotel_managers(:one)
  end

  test "visiting the index" do
    visit hotel_managers_url
    assert_selector "h1", text: "Hotel Managers"
  end

  test "creating a Hotel manager" do
    visit hotel_managers_url
    click_on "New Hotel Manager"

    click_on "Create Hotel manager"

    assert_text "Hotel manager was successfully created"
    click_on "Back"
  end

  test "updating a Hotel manager" do
    visit hotel_managers_url
    click_on "Edit", match: :first

    click_on "Update Hotel manager"

    assert_text "Hotel manager was successfully updated"
    click_on "Back"
  end

  test "destroying a Hotel manager" do
    visit hotel_managers_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Hotel manager was successfully destroyed"
  end
end
