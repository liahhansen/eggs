require 'spec_helper'

describe StockItemsController do
  before(:each) do
    activate_authlogic
    UserSession.create Factory(:admin_user)
  end  

  it "should redirect index when there is no delivery id" do
    get :index
    response.should be_redirect
  end

  it "should render index when a delivery id is given" do
    get :index, :delivery_id => Factory(:delivery)
    response.should be_success
  end

end
