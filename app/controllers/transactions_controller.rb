class TransactionsController < ApplicationController
  # GET /transactions
  # GET /transactions.xml

  access_control do
    allow :admin
    allow :member, :to => [:show, :index]
  end

  def index
    @member = Member.find(params[:member_id])
    @subscription = Subscription.find_by_member_id_and_farm_id(params[:member_id], @farm.id)
    @transactions = Transaction.find_all_by_subscription_id(@subscription.id, @farm.id, :order=>'date')

    balance_snippet = Snippet.find_by_identifier_and_farm_id('balance_details', @farm.id)
    @balance_template = Liquid::Template.parse(balance_snippet.body) if balance_snippet

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @transactions }
    end
  end

  # GET /transactions/1
  # GET /transactions/1.xml
  def show
    @transaction = Transaction.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @transaction }
    end
  end

  # GET /transactions/new
  # GET /transactions/new.xml
  def new
    @transaction = Transaction.new
    @subscription = Subscription.find_by_member_id_and_farm_id(params[:member_id], @farm.id)
    @member = @subscription.member

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @transaction }
    end
  end

  # GET /transactions/1/edit
  def edit
    @transaction = Transaction.find(params[:id])
  end

  # POST /transactions
  # POST /transactions.xml
  def create
    @transaction = Transaction.new(params[:transaction])

    respond_to do |format|
      if @transaction.save
        flash[:notice] = 'Transaction was successfully created.'
        format.html { redirect_to :action => "index", :member_id => params[:member_id], :farm_id => params[:farm_id] }
        format.xml  { render :xml => @transaction, :status => :created, :location => @transaction }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @transaction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /transactions/1
  # PUT /transactions/1.xml
  def update
    @transaction = Transaction.find(params[:id])

    respond_to do |format|
      if @transaction.update_attributes(params[:transaction])
        flash[:notice] = 'Transaction was successfully updated.'
        format.html { redirect_to(@transaction) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @transaction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /transactions/1
  # DELETE /transactions/1.xml
  def destroy
    @transaction = Transaction.find(params[:id])
    @transaction.destroy

    respond_to do |format|
      format.html { redirect_to(transactions_url) }
      format.xml  { head :ok }
    end
  end
end
