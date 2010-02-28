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
        Transaction.stub(:new).with({'these' => 'params'}).and_return(mock_transaction(:save => true))
        post :create, :transaction => {:these => 'params'}
        assigns[:transaction].should equal(mock_transaction)
      end

      it "redirects to the index" do
        Transaction.stub(:new).and_return(mock_transaction(:save => true))
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
