require 'spec_helper'

describe "/transactions/index.html.erb" do
  include TransactionsHelper

  before(:each) do
    assigns[:transactions] = [
      stub_model(Transaction,
        :amount => 1.5,
        :description => "value for description",
        :member_id => 1,
        :order_id => 1
      ),
      stub_model(Transaction,
        :amount => 1.5,
        :description => "value for description",
        :member_id => 1,
        :order_id => 1
      )
    ]
  end

  it "renders a list of transactions" do
    render
    response.should have_tag("tr>td", 1.5.to_s, 2)
    response.should have_tag("tr>td", "value for description".to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
  end
end
