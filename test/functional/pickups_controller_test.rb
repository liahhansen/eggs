require 'test_helper'

class PickupsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pickups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pickup" do
    assert_difference('Pickup.count') do
      post :create, :pickup => { }
    end

    assert_redirected_to pickup_path(assigns(:pickup))
  end

  test "should show pickup" do
    get :show, :id => pickups(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => pickups(:one).to_param
    assert_response :success
  end

  test "should update pickup" do
    put :update, :id => pickups(:one).to_param, :pickup => { }
    assert_redirected_to pickup_path(assigns(:pickup))
  end

  test "should destroy pickup" do
    assert_difference('Pickup.count', -1) do
      delete :destroy, :id => pickups(:one).to_param
    end

    assert_redirected_to pickups_path
  end
end
