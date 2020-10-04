require "application_system_test_case"

class CarRentalsTest < ApplicationSystemTestCase
  setup do
    @car_rental = car_rentals(:one)
  end

  test "visiting the index" do
    visit car_rentals_url
    assert_selector "h1", text: "Car Rentals"
  end

  test "creating a Car rental" do
    visit car_rentals_url
    click_on "New Car Rental"

    click_on "Create Car rental"

    assert_text "Car rental was successfully created"
    click_on "Back"
  end

  test "updating a Car rental" do
    visit car_rentals_url
    click_on "Edit", match: :first

    click_on "Update Car rental"

    assert_text "Car rental was successfully updated"
    click_on "Back"
  end

  test "destroying a Car rental" do
    visit car_rentals_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Car rental was successfully destroyed"
  end
end
