require 'spec_helper'

describe "/transactions/new.html.erb" do
  include TransactionsHelper

  before(:each) do
    assigns[:transaction] = stub_model(Transaction,
      :new_record? => true,
      :amount => 1.5,
      :description => "value for description",
      :member_id => 1,
      :order_id => 1
    )
    assigns[:member] = stub_model(Member)
    assigns[:farm] = stub_model(Farm)
    assigns[:subscription] = stub_model(Subscription)
  end

  it "renders new transaction form" do
    render

    response.should have_tag("form[action=?][method=post]", transactions_path) do
      with_tag("input#transaction_amount[name=?]", "transaction[amount]")
      with_tag("input#transaction_description[name=?]", "transaction[description]")
      with_tag("input#transaction_order_id[name=?]", "transaction[order_id]")
    end
  end
end
