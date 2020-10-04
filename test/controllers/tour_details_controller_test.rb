require 'test_helper'

class TourDetailsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tour_detail = tour_details(:one)
  end

  test "should get index" do
    get tour_details_url
    assert_response :success
  end

  test "should get new" do
    get new_tour_detail_url
    assert_response :success
  end

  test "should create tour_detail" do
    assert_difference('TourDetail.count') do
      post tour_details_url, params: { tour_detail: {  } }
    end

    assert_redirected_to tour_detail_url(TourDetail.last)
  end

  test "should show tour_detail" do
    get tour_detail_url(@tour_detail)
    assert_response :success
  end

  test "should get edit" do
    get edit_tour_detail_url(@tour_detail)
    assert_response :success
  end

  test "should update tour_detail" do
    patch tour_detail_url(@tour_detail), params: { tour_detail: {  } }
    assert_redirected_to tour_detail_url(@tour_detail)
  end

  test "should destroy tour_detail" do
    assert_difference('TourDetail.count', -1) do
      delete tour_detail_url(@tour_detail)
    end

    assert_redirected_to tour_details_url
  end
end
