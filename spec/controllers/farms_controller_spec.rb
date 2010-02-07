require 'spec'
require 'spec_helper'

describe FarmsController do
  before(:each) do
    activate_authlogic
    UserSession.create Factory(:admin_user)
  end


  it "should suceed if we are authenticated" do
    get :index
    response.should be_success
  end

end