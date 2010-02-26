require 'spec_helper'

describe "/transactions/index.html.erb" do
  include TransactionsHelper

  before(:each) do
    activate_authlogic
    farm = Factory(:farm)
    assigns[:farm] = farm
    member = stub_model(Member)
    UserSession.create Factory(:user)
    assigns[:member] = member
    assigns[:subscription] = Factory(:subscription, :farm => farm, :member => member)

    assigns[:transactions] = [
      stub_model(Transaction,
        :amount => 1.5,
        :description => "value for description",
        :order_id => 1233,
        :subscription_id => 2,
        :debit => true
      ),
      stub_model(Transaction,
        :amount => 1.5,
        :description => "value for description",
        :order_id => 1234,
        :subsrcription_id => 2,
        :debit => false
      )
    ]
  end

  it "renders a list of transactions" do
    render
    response.should have_tag("tr>td", number_to_currency(1.5), 2)
    response.should have_tag("tr>td", "value for description".to_s, 2)
  end
end
