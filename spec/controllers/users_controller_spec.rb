require 'spec_helper'

describe UsersController do
  before(:each) do
    activate_authlogic
  end

  it "should let a member view their own page" do
    member = Factory(:member_user)
    UserSession.create member
    get :show, :id => member.id
    response.should be_success
    response.should render_template('home')
  end

  it "should deny a non-admin member from seeing the index of users" do
    member = Factory(:member_user)
    UserSession.create member
    get :index
    response.should render_template('home/access_denied')
  end

  it "should allow an admin to see the index" do
    admin = Factory(:admin_user)
    UserSession.create admin
    get :index
    response.should render_template('index')
  end

end