require "application_system_test_case"

class TourDetailsTest < ApplicationSystemTestCase
  setup do
    @tour_detail = tour_details(:one)
  end

  test "visiting the index" do
    visit tour_details_url
    assert_selector "h1", text: "Tour Details"
  end

  test "creating a Tour detail" do
    visit tour_details_url
    click_on "New Tour Detail"

    click_on "Create Tour detail"

    assert_text "Tour detail was successfully created"
    click_on "Back"
  end

  test "updating a Tour detail" do
    visit tour_details_url
    click_on "Edit", match: :first

    click_on "Update Tour detail"

    assert_text "Tour detail was successfully updated"
    click_on "Back"
  end

  test "destroying a Tour detail" do
    visit tour_details_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tour detail was successfully destroyed"
  end
end
