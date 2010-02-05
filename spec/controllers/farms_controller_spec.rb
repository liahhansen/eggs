require 'spec'
require 'spec_helper'

describe FarmsController do
  before(:each) do
    activate_authlogic
    UserSession.create users(:kathryn)
  end


  it "should succeed if we are not authenticated" do
    get :index
    response.should be_success
  end
end