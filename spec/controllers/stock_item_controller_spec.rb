require 'spec_helper'

describe StockItemsController do

  it "should redirect index" do
    get :index
    response.should be_redirect
  end

end
