require "application_system_test_case"

class ToursTest < ApplicationSystemTestCase
  setup do
    @tour = tours(:one)
  end

  test "visiting the index" do
    visit tours_url
    assert_selector "h1", text: "Tours"
  end

  test "creating a Tour" do
    visit tours_url
    click_on "New Tour"

    fill_in "Comapnay", with: @tour.comapnay
    fill_in "Date", with: @tour.date
    fill_in "Duration", with: @tour.duration
    fill_in "Price", with: @tour.price
    fill_in "Seats", with: @tour.seats
    fill_in "Title", with: @tour.title
    click_on "Create Tour"

    assert_text "Tour was successfully created"
    click_on "Back"
  end

  test "updating a Tour" do
    visit tours_url
    click_on "Edit", match: :first

    fill_in "Comapnay", with: @tour.comapnay
    fill_in "Date", with: @tour.date
    fill_in "Duration", with: @tour.duration
    fill_in "Price", with: @tour.price
    fill_in "Seats", with: @tour.seats
    fill_in "Title", with: @tour.title
    click_on "Update Tour"

    assert_text "Tour was successfully updated"
    click_on "Back"
  end

  test "destroying a Tour" do
    visit tours_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tour was successfully destroyed"
  end
end
