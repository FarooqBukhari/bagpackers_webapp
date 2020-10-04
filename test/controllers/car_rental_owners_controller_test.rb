require 'test_helper'

class CarRentalOwnersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @car_rental_owner = car_rental_owners(:one)
  end

  test "should get index" do
    get car_rental_owners_url
    assert_response :success
  end

  test "should get new" do
    get new_car_rental_owner_url
    assert_response :success
  end

  test "should create car_rental_owner" do
    assert_difference('CarRentalOwner.count') do
      post car_rental_owners_url, params: { car_rental_owner: {  } }
    end

    assert_redirected_to car_rental_owner_url(CarRentalOwner.last)
  end

  test "should show car_rental_owner" do
    get car_rental_owner_url(@car_rental_owner)
    assert_response :success
  end

  test "should get edit" do
    get edit_car_rental_owner_url(@car_rental_owner)
    assert_response :success
  end

  test "should update car_rental_owner" do
    patch car_rental_owner_url(@car_rental_owner), params: { car_rental_owner: {  } }
    assert_redirected_to car_rental_owner_url(@car_rental_owner)
  end

  test "should destroy car_rental_owner" do
    assert_difference('CarRentalOwner.count', -1) do
      delete car_rental_owner_url(@car_rental_owner)
    end

    assert_redirected_to car_rental_owners_url
  end
end
