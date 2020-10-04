require "application_system_test_case"

class HotelReviewsTest < ApplicationSystemTestCase
  setup do
    @hotel_review = hotel_reviews(:one)
  end

  test "visiting the index" do
    visit hotel_reviews_url
    assert_selector "h1", text: "Hotel Reviews"
  end

  test "creating a Hotel review" do
    visit hotel_reviews_url
    click_on "New Hotel Review"

    click_on "Create Hotel review"

    assert_text "Hotel review was successfully created"
    click_on "Back"
  end

  test "updating a Hotel review" do
    visit hotel_reviews_url
    click_on "Edit", match: :first

    click_on "Update Hotel review"

    assert_text "Hotel review was successfully updated"
    click_on "Back"
  end

  test "destroying a Hotel review" do
    visit hotel_reviews_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Hotel review was successfully destroyed"
  end
end
