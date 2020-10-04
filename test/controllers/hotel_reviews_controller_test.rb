require 'test_helper'

class HotelReviewsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @hotel_review = hotel_reviews(:one)
  end

  test "should get index" do
    get hotel_reviews_url
    assert_response :success
  end

  test "should get new" do
    get new_hotel_review_url
    assert_response :success
  end

  test "should create hotel_review" do
    assert_difference('HotelReview.count') do
      post hotel_reviews_url, params: { hotel_review: {  } }
    end

    assert_redirected_to hotel_review_url(HotelReview.last)
  end

  test "should show hotel_review" do
    get hotel_review_url(@hotel_review)
    assert_response :success
  end

  test "should get edit" do
    get edit_hotel_review_url(@hotel_review)
    assert_response :success
  end

  test "should update hotel_review" do
    patch hotel_review_url(@hotel_review), params: { hotel_review: {  } }
    assert_redirected_to hotel_review_url(@hotel_review)
  end

  test "should destroy hotel_review" do
    assert_difference('HotelReview.count', -1) do
      delete hotel_review_url(@hotel_review)
    end

    assert_redirected_to hotel_reviews_url
  end
end
