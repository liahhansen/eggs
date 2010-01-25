require 'spec_helper'

describe PickupsController do

  it "should list pickups only for soul food farm" do
    get :index, :farm_id => farms(:soulfood).id

    response.should be_success

    assigns(:pickups).each do |p|
      p.farm.should == farms(:soulfood)
    end

  end

end
