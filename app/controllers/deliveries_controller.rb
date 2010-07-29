class DeliveriesController < ApplicationController
  # GET /deliveries
  # GET /deliveries.xml
  require "prawn/measurement_extensions"
  prawnto :prawn => { :left_margin => 0.18.in, :right_margin => 0.18.in}

  skip_before_filter :authenticate, :only => "public_summary"

  access_control do
    allow :admin
    deny :member
  end

  def index

    if !params[:farm_id]
      redirect_to root_path
      return
    end

    @deliveries = Delivery.find_all_by_farm_id(params[:farm_id])
    @farm = Farm.find(params[:farm_id])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @deliveries }
    end
  end

  # GET /deliveries/1
  # GET /deliveries/1.xml
  def show

    DeliveryStatusManager.update_statuses

    @delivery = Delivery.find(params[:id])


    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @delivery }
      format.csv do
        csv_string = DeliveryExporter.get_csv(@delivery, params[:tabs])

        send_data csv_string,
                :type => 'text/csv; charset=iso-8859-1; header=present',
                :disposition => "attachment; filename=#{@delivery.date}#{@delivery.name}.csv"
      end
      format.xls do
        xls = DeliveryExporter.get_xls(@delivery)
        data = StringIO.new('')
        xls.write(data)

        send_data data.string, :type=>"application/excel",
                  :disposition=>'attachment',
                  :filename => "#{@delivery.farm.key}-#{@delivery.name}-#{@delivery.date}.xls"
      end


      format.pdf {render :layout => false}
    end
  end

  def show_sheet
    @delivery = Delivery.find(params[:id])
    render :layout => "delivery_fluid"
  end

  def edit_order_totals
    @delivery = Delivery.find(params[:id])
  end

  def public_summary
    @delivery = Delivery.find(params[:id])
  end

  def preview_deductions
    @delivery = Delivery.find(params[:id])
  end

  def submit_deductions
    @delivery = Delivery.find(params[:id])

    if !@delivery.deductions_complete
      if @delivery.perform_deductions!
        flash[:notice] = "Deductions successful!"
        redirect_to :action => 'confirm_deductions', :id => @delivery.id, :farm_id => @farm.id
      end
    end
  end

  def confirm_deductions
    @delivery = Delivery.find(params[:id])
  end

  def setup_emails
    @delivery = Delivery.find(params[:id])
    @email_templates = EmailTemplate.find_all_by_farm_id(@farm.id)
    
  end

  def customize_emails
    @delivery = Delivery.find(params[:id])
    @email_template = EmailTemplate.find(params[:email_template])
  end

  def preview_emails
    @delivery = Delivery.find(params[:id])
    @email_template = EmailTemplate.find(params[:email_template])
    @email_template.subject = params[:email_subject]
    @email_template.body = params[:email_body]

    if !@email_template.valid?
      render :action => 'customize_emails'
    end
  end

  def send_emails
    @delivery = Delivery.find(params[:id])
    @email_template = EmailTemplate.find(params[:email_template])
    @email_template.subject = params[:email_subject]
    @email_template.body = params[:email_body]

    @delivery.orders.each do |order|
      @email_template.deliver_to(order.member.email_address, :order => order)
    end

    @delivery.update_attribute("email_reminder_sent", true) if @email_template.name == "Order Pickup Reminder"
    @delivery.update_attribute("email_totals_sent", true) if @email_template.name == "Order Total and Balance Notification"

    flash[:notice] = "Emails sent to #{@delivery.orders.size} recipients."
    redirect_to :action => "show", :id => @delivery.id, :farm_id => @farm.id

  end

  # GET /deliveries/new
  # GET /deliveries/new.xml
  def new
    @delivery = Delivery.new_from_farm(@farm)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @delivery }
    end
  end

  # GET /deliveries/1/edit
  def edit
    @delivery = Delivery.find(params[:id])
  end

  # POST /deliveries
  # POST /deliveries.xml
  def create
    @delivery = Delivery.new(params[:delivery])

    respond_to do |format|
      if params[:location_ids] && @delivery.save
        @delivery.create_pickups(params[:location_ids])

        ReminderManager.new.schedule_reminders_for_delivery(@delivery)

        flash[:notice] = 'Delivery was successfully created.'
        format.html { redirect_to :action => "show", :id => @delivery.id, :farm_id => @farm.id }
        format.xml  { render :xml => @delivery, :status => :created, :location => @delivery }
      else
        if !params[:location_ids]
          @delivery.errors.add_to_base "You must specify at least one Location"
        end
        format.html { render :action => "new" }
        format.xml  { render :xml => @delivery.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /deliveries/1
  # PUT /deliveries/1.xml
  def update
    @delivery = Delivery.find(params[:id])

    respond_to do |format|
      if @delivery.update_attributes(params[:delivery])

        if params[:totals]
          @delivery.update_attribute(:finalized_totals, true)
        end

        flash[:notice] = 'Delivery was successfully updated.'
        format.html { redirect_to :action => "show", :id => @delivery.id, :farm_id => @farm.id }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @delivery.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /deliveries/1
  # DELETE /deliveries/1.xml
  def destroy
    @delivery = Delivery.find(params[:id])
    @delivery.destroy

    respond_to do |format|
      format.html { redirect_to(@farm) }
      format.xml  { head :ok }
    end
  end
end
