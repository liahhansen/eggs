require 'spec_helper'

describe "/orders/show.html.erb" do
  include OrdersHelper
  before(:each) do
    activate_authlogic    
    assigns[:order] = @order = Factory(:order_with_items)
  end



  it "should show edit if logged in as admin" do
    UserSession.create Factory(:admin_user)
    render
    response.should include_text("Edit")
  end

  it "should show edit if logged in as member and order pickup is open" do
    user = Factory(:member_user)
    assigns[:order] = @order = Factory(:order_with_items, :member => user.member, :pickup => Factory(:pickup, :status => "open"))
    UserSession.create user
    render
    response.should include_text("Edit")
  end

  it "should not show edit if logged in as member and order pickup status is not open" do
    user = Factory(:member_user)
    assigns[:order] = @order = Factory(:order_with_items, :member => user.member, :pickup => Factory(:pickup, :status => "finalized"))
    UserSession.create user
    render
    response.should_not include_text("Edit")
  end

end
