class ProductQuestionsController < ApplicationController

  access_control do
    allow :admin
    deny  :member
  end

  def index
    @product_questions = ProductQuestion.find_all_by_farm_id(@farm.id)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @product_questions }
    end
  end

  def show
    @product_question = ProductQuestion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @product_question }
    end
  end

  def new
    @product_question = ProductQuestion.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @product_question }
    end
  end

  def edit
    @product_question = ProductQuestion.find(params[:id])
  end

  def create
    @product_question = ProductQuestion.new(params[:product_question])

    respond_to do |format|
      if @product_question.save
        flash[:notice] = 'Product Question was successfully created.'
        format.html { redirect_to :action => "index", :farm_id => @farm.id }
        format.xml  { render :xml => @product_question, :status => :created, :location => @product_question }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @product_question.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @product_question = ProductQuestion.find(params[:id])

    respond_to do |format|
      if @product_question.update_attributes(params[:product_question])
        flash[:notice] = 'Product Question was successfully updated.'
        format.html { redirect_to :action => "index", :farm_id => @farm.id }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @product_question.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @product_question = ProductQuestion.find(params[:id])
    @product_question.destroy
    flash[:notice] = 'Product Question was successfully deleted.'

    respond_to do |format|
      format.html { redirect_to :action => "index", :farm_id => @farm.id }
      format.xml  { head :ok }
    end
  end
end
