require "application_system_test_case"

class CarRentalOwnersTest < ApplicationSystemTestCase
  setup do
    @car_rental_owner = car_rental_owners(:one)
  end

  test "visiting the index" do
    visit car_rental_owners_url
    assert_selector "h1", text: "Car Rental Owners"
  end

  test "creating a Car rental owner" do
    visit car_rental_owners_url
    click_on "New Car Rental Owner"

    click_on "Create Car rental owner"

    assert_text "Car rental owner was successfully created"
    click_on "Back"
  end

  test "updating a Car rental owner" do
    visit car_rental_owners_url
    click_on "Edit", match: :first

    click_on "Update Car rental owner"

    assert_text "Car rental owner was successfully updated"
    click_on "Back"
  end

  test "destroying a Car rental owner" do
    visit car_rental_owners_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Car rental owner was successfully destroyed"
  end
end
