require 'spec_helper'

describe UsersController do
  before(:each) do
    activate_authlogic
  end

  it "should let a member view their own page" do
    user = Factory(:member_user)
    farm = Factory(:farm)
    Factory(:subscription, :farm => farm, :member => user.member)
    UserSession.create user
    get :show, :id => user.member.id, :farm_id => farm.id
    response.should be_success
    response.should render_template('home')
  end

  it "should deny a non-admin member from seeing the index of users" do
    user = Factory(:member_user)
    UserSession.create user
    get :index
    response.should render_template('home/access_denied')
  end

  it "should allow an admin to see the index" do
    admin = Factory(:admin_user)
    UserSession.create admin
    get :index, :farm_id => Factory(:farm).id
    response.should render_template('index')
  end

  it "should only have users from the specified farm in index" do
    admin = Factory(:admin_user)
    UserSession.create admin

    farm1 = Factory(:farm_with_members)
    farm2 = Factory(:farm_with_members)

    get :index, :farm_id => farm1.id

    assigns(:users).each do |user|
      user.member.farms.include?(farm1).should == true
    end
  end

end