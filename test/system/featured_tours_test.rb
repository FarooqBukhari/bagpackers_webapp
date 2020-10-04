require "application_system_test_case"

class FeaturedToursTest < ApplicationSystemTestCase
  setup do
    @featured_tour = featured_tours(:one)
  end

  test "visiting the index" do
    visit featured_tours_url
    assert_selector "h1", text: "Featured Tours"
  end

  test "creating a Featured tour" do
    visit featured_tours_url
    click_on "New Featured Tour"

    click_on "Create Featured tour"

    assert_text "Featured tour was successfully created"
    click_on "Back"
  end

  test "updating a Featured tour" do
    visit featured_tours_url
    click_on "Edit", match: :first

    click_on "Update Featured tour"

    assert_text "Featured tour was successfully updated"
    click_on "Back"
  end

  test "destroying a Featured tour" do
    visit featured_tours_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Featured tour was successfully destroyed"
  end
end
