require 'test_helper'

class TripOrganizersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @trip_organizer = trip_organizers(:one)
  end

  test "should get index" do
    get trip_organizers_url
    assert_response :success
  end

  test "should get new" do
    get new_trip_organizer_url
    assert_response :success
  end

  test "should create trip_organizer" do
    assert_difference('TripOrganizer.count') do
      post trip_organizers_url, params: { trip_organizer: {  } }
    end

    assert_redirected_to trip_organizer_url(TripOrganizer.last)
  end

  test "should show trip_organizer" do
    get trip_organizer_url(@trip_organizer)
    assert_response :success
  end

  test "should get edit" do
    get edit_trip_organizer_url(@trip_organizer)
    assert_response :success
  end

  test "should update trip_organizer" do
    patch trip_organizer_url(@trip_organizer), params: { trip_organizer: {  } }
    assert_redirected_to trip_organizer_url(@trip_organizer)
  end

  test "should destroy trip_organizer" do
    assert_difference('TripOrganizer.count', -1) do
      delete trip_organizer_url(@trip_organizer)
    end

    assert_redirected_to trip_organizers_url
  end
end
