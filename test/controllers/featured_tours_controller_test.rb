require 'test_helper'

class FeaturedToursControllerTest < ActionDispatch::IntegrationTest
  setup do
    @featured_tour = featured_tours(:one)
  end

  test "should get index" do
    get featured_tours_url
    assert_response :success
  end

  test "should get new" do
    get new_featured_tour_url
    assert_response :success
  end

  test "should create featured_tour" do
    assert_difference('FeaturedTour.count') do
      post featured_tours_url, params: { featured_tour: {  } }
    end

    assert_redirected_to featured_tour_url(FeaturedTour.last)
  end

  test "should show featured_tour" do
    get featured_tour_url(@featured_tour)
    assert_response :success
  end

  test "should get edit" do
    get edit_featured_tour_url(@featured_tour)
    assert_response :success
  end

  test "should update featured_tour" do
    patch featured_tour_url(@featured_tour), params: { featured_tour: {  } }
    assert_redirected_to featured_tour_url(@featured_tour)
  end

  test "should destroy featured_tour" do
    assert_difference('FeaturedTour.count', -1) do
      delete featured_tour_url(@featured_tour)
    end

    assert_redirected_to featured_tours_url
  end
end
