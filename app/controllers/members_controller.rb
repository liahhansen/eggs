class MembersController < ApplicationController
  # GET /members
  # GET /members.xml

  skip_before_filter :authenticate, :only => [:new, :create, :confirm]

  access_control do
    allow :admin
    allow all, :to => [:new, :create, :confirm]
  end

  def index
    @members = @farm.members :include => :user

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @members }
      format.json { render :json => @members }
    end
  end

  # GET /members/1
  # GET /members/1.xml
  def show
    @member = Member.find(params[:id])
    @subscription = Subscription.find_by_member_id_and_farm_id(@member.id,@farm.id)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @member }
    end
  end

  # GET /members/new
  # GET /members/new.xml
  def new
    @farm = Farm.find_by_subdomain(request.subdomains.first) unless @farm
    @member = Member.new

    @new_member_template = Snippet.get_template("new_member", @farm)    

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @member }
    end
  end

  # GET /members/1/edit
  def edit
    @member = Member.find(params[:id])
    @subscription = @member.subscription_for_farm(@farm)
  end

  # POST /members
  # POST /members.xml
  def create
    @member = Member.new(params[:member])

    respond_to do |format|
      ActiveRecord::Base.transaction do
        if @member.save
          Subscription.create!(:farm => @farm, :member => @member,
                               :referral => params[:referral],
                               :deposit_type => params[:deposit_type])
          @user = User.new
          if @user.signup!(:member_id => @member.id, :email => params[:member][:email_address])
            @user.has_role!(:member)
            @user.reset_perishable_token!
            @user.deliver_activation_instructions!(register_url(@user.perishable_token))
          end

          if(current_user && current_user.has_role?(:admin))
            flash[:notice] = 'Member was successfully created.'
            format.html { redirect_to :action => "index", :farm_id => @farm.id }
          else
            format.html { render :action => "confirm", :farm_id => @farm.id }
          end
        else
          format.html { render :action => "new" }
        end
      end
    end
  end

  def confirm
    
  end

  # PUT /members/1
  # PUT /members/1.xml
  def update
    @member = Member.find(params[:id])
    @subscription = @member.subscription_for_farm(@farm)

    pending = params[:pending] || false
    deposit_received = params[:deposit_received] || false
    joined_mailing_list = params[:joined_mailing_list] || false
    private_notes = params[:private_notes]


    respond_to do |format|
      if @member.update_attributes(params[:member])
        @subscription.update_attributes!(:pending => pending,
                                        :deposit_received => deposit_received,
                                        :joined_mailing_list => joined_mailing_list,
                                        :private_notes => private_notes)
        flash[:notice] = 'Member was successfully updated.'
        format.html { redirect_to :action => "show", :id => @member.id, :farm_id => @farm.id }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @member.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /members/1
  # DELETE /members/1.xml
  def destroy
    @member = Member.find(params[:id])
    @member.destroy
    flash[:notice] = 'Member was successfully deleted.'

    respond_to do |format|
      format.html { redirect_to :action => "index", :farm_id => @farm.id }
      format.xml  { head :ok }
    end
  end
end
