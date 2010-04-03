class MembersController < ApplicationController
  # GET /members
  # GET /members.xml

  access_control do
    allow :admin
  end

  def index
    @members = Member.all :joins => :subscriptions, :conditions => {:subscriptions => {:farm_id => @farm.id}}, :order => 'last_name, first_name'

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @members }
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
    @member = Member.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @member }
    end
  end

  # GET /members/1/edit
  def edit
    @member = Member.find(params[:id])
  end

  # POST /members
  # POST /members.xml
  def create
    @member = Member.new(params[:member])

    respond_to do |format|
      ActiveRecord::Base.transaction do
        if @member.save
          Subscription.create!(:farm => @farm, :member => @member )
          @user = User.new
          if @user.signup!(:member => @member, :email => params[:member][:email_address])
            @user.deliver_activation_instructions!
            @user.has_role!(:member)
          end

          flash[:notice] = 'Member was successfully created.'
          format.html { redirect_to :action => "index", :farm_id => @farm.id }
          format.xml  { render :xml => @member, :status => :created, :location => @member }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @member.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /members/1
  # PUT /members/1.xml
  def update
    @member = Member.find(params[:id])

    respond_to do |format|
      if @member.update_attributes(params[:member])
        flash[:notice] = 'Member was successfully updated.'
        format.html { redirect_to :action => "index", :farm_id => @farm.id }
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
