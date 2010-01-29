require 'spec_helper'

describe StockItemsController do

  it "should redirect index when there is no pickup id" do
    get :index
    response.should be_redirect
  end

  it "should render index when a pickup id is given" do
    get :index, :pickup_id => Pickup.find_by_name("Emeryville")
    response.should be_success
  end

end
