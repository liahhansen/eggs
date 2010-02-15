require 'spec_helper'

describe "/transactions/show.html.erb" do
  include TransactionsHelper
  before(:each) do
    assigns[:transaction] = @transaction = stub_model(Transaction,
      :amount => 1.5,
      :description => "value for description",
      :member_id => 1,
      :order_id => 1
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/1\.5/)
    response.should have_text(/value\ for\ description/)
    response.should have_text(/1/)
    response.should have_text(/1/)
  end
end
