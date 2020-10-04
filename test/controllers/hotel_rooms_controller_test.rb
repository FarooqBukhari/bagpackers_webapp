require 'test_helper'

class HotelRoomsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @hotel_room = hotel_rooms(:one)
  end

  test "should get index" do
    get hotel_rooms_url
    assert_response :success
  end

  test "should get new" do
    get new_hotel_room_url
    assert_response :success
  end

  test "should create hotel_room" do
    assert_difference('HotelRoom.count') do
      post hotel_rooms_url, params: { hotel_room: {  } }
    end

    assert_redirected_to hotel_room_url(HotelRoom.last)
  end

  test "should show hotel_room" do
    get hotel_room_url(@hotel_room)
    assert_response :success
  end

  test "should get edit" do
    get edit_hotel_room_url(@hotel_room)
    assert_response :success
  end

  test "should update hotel_room" do
    patch hotel_room_url(@hotel_room), params: { hotel_room: {  } }
    assert_redirected_to hotel_room_url(@hotel_room)
  end

  test "should destroy hotel_room" do
    assert_difference('HotelRoom.count', -1) do
      delete hotel_room_url(@hotel_room)
    end

    assert_redirected_to hotel_rooms_url
  end
end
