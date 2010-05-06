require 'spec_helper'

describe MembersController do
  before(:each) do
    activate_authlogic
  end

#  it "should let a member view their own page" do
#    user = Factory(:member_user)
#    farm = Factory(:farm)
#    Factory(:subscription, :farm => farm, :member => user.member)
#    UserSession.create user
#    get :show, :id => user.member.id, :farm_id => farm.id
#    response.should be_success
#    response.should render_template('home')
#  end
#
#  it "should deny a non-admin member from seeing the index of users" do
#    user = Factory(:member_user)
#    UserSession.create user
#    get :index
#    response.should render_template('home/access_denied')
#  end
#
#  it "should allow an admin to see the index" do
#    admin = Factory(:admin_user)
#    UserSession.create admin
#    get :index, :farm_id => Factory(:farm).id
#    response.should render_template('index')
#  end

  it "should only have members from the specified farm in index" do
    admin = Factory(:admin_user)
    UserSession.create admin

    farm1 = Factory(:farm_with_members)
    farm2 = Factory(:farm_with_members)

    get :index, :farm_id => farm1.id

    assigns(:members).each do |member|
      member.farms.include?(farm1).should == true
    end
  end

  it "should create a user, subscription, and assign roles when creating a member" do
    admin = Factory(:admin_user)
    UserSession.create admin

    farm = Factory(:farm)
    Role.create!(:name => "member")

    get :create, :farm_id => farm.id, :member => {:email_address => 'jj@example.com','first_name' => 'Jay','last_name' => 'Jay','phone_number'=>'123'}
    
    assigns[:member].should_not be_nil
    assigns[:user].member.should == assigns[:member]
    assigns[:member].subscriptions.first.farm.should == farm
    assigns[:user].has_role?(:member).should == true

  end

end