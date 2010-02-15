require 'spec_helper'

describe "/transactions/edit.html.erb" do
  include TransactionsHelper

  before(:each) do
    assigns[:transaction] = @transaction = stub_model(Transaction,
      :new_record? => false,
      :amount => 1.5,
      :description => "value for description",
      :member_id => 1,
      :order_id => 1
    )
  end

  it "renders the edit transaction form" do
    render

    response.should have_tag("form[action=#{transaction_path(@transaction)}][method=post]") do
      with_tag('input#transaction_amount[name=?]', "transaction[amount]")
      with_tag('input#transaction_description[name=?]', "transaction[description]")
      with_tag('input#transaction_member_id[name=?]', "transaction[member_id]")
      with_tag('input#transaction_order_id[name=?]', "transaction[order_id]")
    end
  end
end
