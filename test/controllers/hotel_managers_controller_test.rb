require 'test_helper'

class HotelManagersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @hotel_manager = hotel_managers(:one)
  end

  test "should get index" do
    get hotel_managers_url
    assert_response :success
  end

  test "should get new" do
    get new_hotel_manager_url
    assert_response :success
  end

  test "should create hotel_manager" do
    assert_difference('HotelManager.count') do
      post hotel_managers_url, params: { hotel_manager: {  } }
    end

    assert_redirected_to hotel_manager_url(HotelManager.last)
  end

  test "should show hotel_manager" do
    get hotel_manager_url(@hotel_manager)
    assert_response :success
  end

  test "should get edit" do
    get edit_hotel_manager_url(@hotel_manager)
    assert_response :success
  end

  test "should update hotel_manager" do
    patch hotel_manager_url(@hotel_manager), params: { hotel_manager: {  } }
    assert_redirected_to hotel_manager_url(@hotel_manager)
  end

  test "should destroy hotel_manager" do
    assert_difference('HotelManager.count', -1) do
      delete hotel_manager_url(@hotel_manager)
    end

    assert_redirected_to hotel_managers_url
  end
end
