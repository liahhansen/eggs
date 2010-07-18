class TransactionsController < ApplicationController

  include ActiveMerchant::Billing::Integrations

  skip_before_filter :authenticate, :only => [:ipn] 
  protect_from_forgery :except => [:ipn]

  access_control do
    allow :admin
    allow :member, :to => [:show, :index]
    allow all, :to => "ipn"
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
        @transaction.deliver_credit_notification! if !@transaction.debit
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

  def ipn
    notify = Paypal::Notification.new(request.raw_post)
    @farm = Farm.find_by_paypal_account(params[:business])


    # we must make sure this transaction id is not already completed
    if !Transaction.count("*", :conditions => ["paypal_transaction_id = ?", notify.transaction_id]).zero?
      Notifier.deliver_admin_notification({:subject => 'Duplicate Transaction Attempt',
                                          :body => <<EOS 
This PayPal payment has previously been entered and is being ignored.
Probably nothing to worry about - I'm just sending a notification for everything right now.

  Paypal Transaction ID: #{notify.transaction_id}
  Payer Email Address: #{params[:payer_email]}
  Sent to Business: #{params[:business]}
  Amount: $#{notify.amount}
EOS
}, @farm)
      return
    end

    if notify.item_id != '' && notify.item_id != nil
      subscription = Subscription.find(notify.item_id)
    else

      if Member.exists?(:email_address => params[:payer_email])
        member = Member.find_by_email_address(params[:payer_email])
        subscription = member.subscription_for_farm(@farm)
      elsif Member.exists?(:alternate_email => params[:payer_email])
        member = Member.find_by_alternate_email(params[:payer_email])
        subscription = member.subscription_for_farm(@farm)
      else
        Notifier.deliver_admin_notification({:subject => 'PayPal payment from unknown member',
           :body => <<EOS 
Unable to locate member for Paypal Transaction:

  Paypal Transaction ID: #{notify.transaction_id}
  Payer Email Address: #{params[:payer_email]}
  Sent to Business: #{params[:business]}
  Amount: $#{notify.amount}
EOS
},@farm)

        return
      end
    end

    if notify.acknowledge
      begin
        if notify.complete?
          transaction = subscription.transactions.create(:date => Date.today,
                                           :amount => notify.amount,
                                           :paypal_transaction_id => notify.transaction_id,
                                           :debit => false,
                                           :description => "Paypal payment #{notify.transaction_id}"
                                           )

          transaction.deliver_credit_notification!
        else
           #Reason to be suspicious
            Notifier.deliver_admin_notification({:subject => 'Unusual PayPal notification ',
              :body => <<EOS
This PayPal payment wasn't able to be added.  Maybe it's not complete?:

  Paypal Transaction ID: #{notify.transaction_id}
  Payer Email Address: #{params[:payer_email]}
  Sent to Business: #{params[:business]}
  Amount: $#{notify.amount}
EOS
              },@farm)
        end

      rescue => e
        #Houston we have a bug
      ensure
        #make sure we logged everything we must
      end
    else #transaction was not acknowledged
Notifier.deliver_admin_notification({:subject => 'Suspicious Paypal Notification',
              :body => <<EOS
This PayPal notification doesn't seem to be verified by PayPal and has not been entered.
Double check the validity of the payment before entering manually.

  Paypal Transaction ID: #{notify.transaction_id}
  Payer Email Address: #{params[:payer_email]}
  Sent to Business: #{params[:business]}
  Amount: $#{notify.amount}
EOS
              },@farm)    end

    render :nothing => true
  end




end
