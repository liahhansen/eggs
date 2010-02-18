require 'spec_helper'

describe "/transactions/index.html.erb" do
  include TransactionsHelper

  before(:each) do
    farm = Factory(:farm)
    assigns[:farm] = farm
    member = Factory(:member)
    assigns[:member] = member

    assigns[:transactions] = [
      stub_model(Transaction,
        :amount => 1.5,
        :description => "value for description",
        :member_id => member.id,
        :order_id => 1233,
        :farm_id => farm.id
      ),
      stub_model(Transaction,
        :amount => 1.5,
        :description => "value for description",
        :member_id => member.id,
        :order_id => 1234,
        :farm_id => farm.id
      )
    ]
  end

  it "renders a list of transactions" do
    render
    response.should have_tag("tr>td", number_to_currency(1.5), 2)
    response.should have_tag("tr>td", "value for description".to_s, 2)
  end
end
