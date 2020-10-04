require 'test_helper'

class CustomTripsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @custom_trip = custom_trips(:one)
  end

  test "should get index" do
    get custom_trips_url
    assert_response :success
  end

  test "should get new" do
    get new_custom_trip_url
    assert_response :success
  end

  test "should create custom_trip" do
    assert_difference('CustomTrip.count') do
      post custom_trips_url, params: { custom_trip: { childs: @custom_trip.childs, departure_city: @custom_trip.departure_city, departure_date: @custom_trip.departure_date, number_of_days: @custom_trip.number_of_days, rooms: @custom_trip.rooms, seats: @custom_trip.seats } }
    end

    assert_redirected_to custom_trip_url(CustomTrip.last)
  end

  test "should show custom_trip" do
    get custom_trip_url(@custom_trip)
    assert_response :success
  end

  test "should get edit" do
    get edit_custom_trip_url(@custom_trip)
    assert_response :success
  end

  test "should update custom_trip" do
    patch custom_trip_url(@custom_trip), params: { custom_trip: { childs: @custom_trip.childs, departure_city: @custom_trip.departure_city, departure_date: @custom_trip.departure_date, number_of_days: @custom_trip.number_of_days, rooms: @custom_trip.rooms, seats: @custom_trip.seats } }
    assert_redirected_to custom_trip_url(@custom_trip)
  end

  test "should destroy custom_trip" do
    assert_difference('CustomTrip.count', -1) do
      delete custom_trip_url(@custom_trip)
    end

    assert_redirected_to custom_trips_url
  end
end
