require 'test_helper'

class StockItemsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stock_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create stock_item" do
    assert_difference('StockItem.count') do
      post :create, :stock_item => { }
    end

    assert_redirected_to stock_item_path(assigns(:stock_item))
  end

  test "should show stock_item" do
    get :show, :id => stock_items(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => stock_items(:one).to_param
    assert_response :success
  end

  test "should update stock_item" do
    put :update, :id => stock_items(:one).to_param, :stock_item => { }
    assert_redirected_to stock_item_path(assigns(:stock_item))
  end

  test "should destroy stock_item" do
    assert_difference('StockItem.count', -1) do
      delete :destroy, :id => stock_items(:one).to_param
    end

    assert_redirected_to stock_items_path
  end
end
