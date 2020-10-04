require 'test_helper'

class CarRentalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @car_rental = car_rentals(:one)
  end

  test "should get index" do
    get car_rentals_url
    assert_response :success
  end

  test "should get new" do
    get new_car_rental_url
    assert_response :success
  end

  test "should create car_rental" do
    assert_difference('CarRental.count') do
      post car_rentals_url, params: { car_rental: {  } }
    end

    assert_redirected_to car_rental_url(CarRental.last)
  end

  test "should show car_rental" do
    get car_rental_url(@car_rental)
    assert_response :success
  end

  test "should get edit" do
    get edit_car_rental_url(@car_rental)
    assert_response :success
  end

  test "should update car_rental" do
    patch car_rental_url(@car_rental), params: { car_rental: {  } }
    assert_redirected_to car_rental_url(@car_rental)
  end

  test "should destroy car_rental" do
    assert_difference('CarRental.count', -1) do
      delete car_rental_url(@car_rental)
    end

    assert_redirected_to car_rentals_url
  end
end
