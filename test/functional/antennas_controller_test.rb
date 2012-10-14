require 'test_helper'

class AntennasControllerTest < ActionController::TestCase
  setup do
    @antenna = antennas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:antennas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create antenna" do
    assert_difference('Antenna.count') do
      post :create, antenna: @antenna.attributes
    end

    assert_redirected_to antenna_path(assigns(:antenna))
  end

  test "should show antenna" do
    get :show, id: @antenna
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @antenna
    assert_response :success
  end

  test "should update antenna" do
    put :update, id: @antenna, antenna: @antenna.attributes
    assert_redirected_to antenna_path(assigns(:antenna))
  end

  test "should destroy antenna" do
    assert_difference('Antenna.count', -1) do
      delete :destroy, id: @antenna
    end

    assert_redirected_to antennas_path
  end
end
