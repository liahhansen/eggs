require 'spec_helper'

describe StockItemsController do
  before(:each) do
    activate_authlogic
    UserSession.create Factory(:user)
  end  

  it "should redirect index when there is no pickup id" do
    get :index
    response.should be_redirect
  end

  it "should render index when a pickup id is given" do
    get :index, :pickup_id => Factory(:pickup)
    response.should be_success
  end

end
