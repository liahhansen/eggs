require 'spec_helper'

describe TransactionsController do

  before(:each) do
    @farm = Factory(:farm)
    activate_authlogic
    UserSession.create Factory(:admin_user)

    @member = UserSession.find.user.member
    @subscription = Factory(:subscription, :farm => @farm, :member => @member)
  end

  def mock_transaction(stubs={})
    @mock_transaction ||= mock_model(Transaction, stubs)
  end

  def mock_member(stubs={})
    @mock_member ||= mock_model(Member, stubs)
  end


  describe "Paypal Transactions" do

    describe "acknowledge" do

      before(:each) do

        @subscription = Factory(:subscription)

        @trans_id = "16F08736TA389152H"
        @ipn_params = {"payment_date" => "04:33:33 Oct 13.2007+PDT" ,
          "txn_type" => "web_accept",
          "last_name" => @subscription.member.last_name,
          "residence_country" => "US",
          "item_name" => "CSA top-up",
          "payment_gross" => "100.00",
          "mc_currency" => "USD",
          "business" => @subscription.farm.paypal_account,
          "payment_type" => "instant",
          "verify_sign" => "AZQLcOZ7B.YM2m-QDAXOrQQcLFYuA0N0XoC3zadaGhkGNF2nlRWmpzlI",
          "payer_status" => "verified",
          "test_ipn" => "1",
          "tax" => "0.00",
          "payer_email" => @subscription.member.email_address ,
          "txn_id" => @trans_id,
          "quantity" => "1",
          "receiver_email" => 'receivertest@example.com',
          "first_name" => @subscription.member.first_name,
          "invoice" => nil,
          "payer_id" =>  '2094040',
          "receiver_id" => '3934949',
          "item_number" => @subscription.id,
          "payment_status" => "Completed",
          "payment_fee" => "5.52",
          "mc_fee" => "5.52",
          "shipping" => "0.00",
          "mc_gross" => "100.00",
          "custom" => @subscription.farm.id,
          "charset" => "windows-1252",
          "notify_version" => "2.4"
        }




      end

      it "acknowledges a successful transaction" do

        @subscription.transactions.count.should == 0
        post :ipn, @ipn_params.merge("acknowledge" => "true")
        response.should be_success
        @subscription.transactions.count.should == 1
        @subscription.current_balance.should == 100

      end

      it "should refuse a second attempt with that id" do

        post :ipn, @ipn_params.merge("acknowledge" => "true")
        post :ipn, @ipn_params.merge("acknowledge" => "true")
        response.should be_success

        @subscription.transactions.count.should == 1
        @subscription.current_balance.should == 100

      end

      it "should look up a subscription by email address if no id is given" do
        post :ipn, @ipn_params.merge("acknowledge" => "true", "item_number" => nil)
        @subscription.transactions.count.should == 1
        @subscription.current_balance.should == 100
      end

      it "should look up the subscription by alternate email, too" do
        @subscription.member.update_attribute(:alternate_email, "myalternate@example.com")
        post :ipn, @ipn_params.merge("acknowledge" => "true",
                                     "item_number" => nil,
                                     "payer_email" => @subscription.member.alternate_email)

        @subscription.transactions.count.should == 1
        @subscription.current_balance.should == 100
        
      end

      it "can look up farm by paypal_account" do
        post :ipn, @ipn_params.merge("acknowledge" => "true", "item_number" => nil)


      end


    end

  end



  describe "GET index" do
    it "assigns all transactions for a specified user as @transactions" do
      UserSession.create Factory(:member_user)      
      member = UserSession.find.user.member
      farm = Factory(:farm)
      sub = Factory(:subscription, :farm => farm, :member => member)
      Factory(:transaction)
      Factory(:transaction, :subscription => sub)

      get :index, :member_id => member.id, :farm_id => farm.id
      assigns[:transactions].length.should == 1
    end
  end

  describe "GET show" do
    it "assigns the requested transaction as @transaction" do
      Transaction.stub(:find).with("37").and_return(mock_transaction)
      get :show, :id => "37"
      assigns[:transaction].should equal(mock_transaction)
    end
  end

  describe "GET new" do
    it "assigns a new transaction as @transaction and member as @member" do
      get :new, :member_id => @member.id, :farm_id => @farm.id
      assigns[:transaction].class.should == Transaction
    end

    it "assigns a member as @member" do
      get :new, :member_id => @member.id, :farm_id => @farm.id
      assigns[:member].should == @member
    end
  end

  describe "GET edit" do
    it "assigns the requested transaction as @transaction" do
      Transaction.stub(:find).with("37").and_return(mock_transaction)
      get :edit, :id => "37"
      assigns[:transaction].should equal(mock_transaction)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created transaction as @transaction" do
        Transaction.stub(:new).with({'these' => 'params'}).and_return(mock_transaction(:save => true, :debit=>false, "deliver_credit_notification!"=>nil))
        post :create, :transaction => {:these => 'params'}
        assigns[:transaction].should equal(mock_transaction)
      end

      it "redirects to the index" do
        Transaction.stub(:new).and_return(mock_transaction(:save => true, :debit=>false, "deliver_credit_notification!"=>nil))
        post :create, :transaction => {}
        response.should redirect_to(transactions_url)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved transaction as @transaction" do
        Transaction.stub(:new).with({'these' => 'params'}).and_return(mock_transaction(:save => false))
        post :create, :transaction => {:these => 'params'}
        assigns[:transaction].should equal(mock_transaction)
      end

      it "re-renders the 'new' template" do
        Transaction.stub(:new).and_return(mock_transaction(:save => false))
        post :create, :transaction => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested transaction" do
        Transaction.should_receive(:find).with("37").and_return(mock_transaction)
        mock_transaction.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :transaction => {:these => 'params'}
      end

      it "assigns the requested transaction as @transaction" do
        Transaction.stub(:find).and_return(mock_transaction(:update_attributes => true))
        put :update, :id => "1"
        assigns[:transaction].should equal(mock_transaction)
      end

      it "redirects to the transaction" do
        Transaction.stub(:find).and_return(mock_transaction(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(transaction_url(mock_transaction))
      end
    end

    describe "with invalid params" do
      it "updates the requested transaction" do
        Transaction.should_receive(:find).with("37").and_return(mock_transaction)
        mock_transaction.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :transaction => {:these => 'params'}
      end

      it "assigns the transaction as @transaction" do
        Transaction.stub(:find).and_return(mock_transaction(:update_attributes => false))
        put :update, :id => "1"
        assigns[:transaction].should equal(mock_transaction)
      end

      it "re-renders the 'edit' template" do
        Transaction.stub(:find).and_return(mock_transaction(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested transaction" do
      Transaction.should_receive(:find).with("37").and_return(mock_transaction)
      mock_transaction.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the transactions list" do
      Transaction.stub(:find).and_return(mock_transaction(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(transactions_url)
    end
  end



end
