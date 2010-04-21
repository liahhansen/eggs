require 'spec_helper'

describe EmailTemplatesController do
  before(:each) do
    activate_authlogic
    UserSession.create Factory(:admin_user)
    @farm = Factory(:farm)
  end


  def mock_email_template(stubs={})
    @mock_email_template ||= mock_model(EmailTemplate, stubs)
  end


  describe "GET index" do
    it "assigns all email_templates as @email_templates" do
      EmailTemplate.stub(:find).with(:all).and_return([mock_email_template])

      get :index, :farm_id => @farm.id
      assigns[:email_templates].should == [mock_email_template]
    end
  end

  describe "GET show" do
    it "assigns the requested email_template as @email_template" do
      EmailTemplate.stub(:find).with("37").and_return(mock_email_template)
      get :show, :id => "37", :farm_id => @farm.id
      assigns[:email_template].should equal(mock_email_template)
    end
  end

  describe "GET new" do
    it "assigns a new email_template as @email_template" do
      EmailTemplate.stub(:new).and_return(mock_email_template)
      get :new, :farm_id => @farm.id
      assigns[:email_template].should equal(mock_email_template)
    end
  end

  describe "GET edit" do
    it "assigns the requested email_template as @email_template" do
      EmailTemplate.stub(:find).with("37").and_return(mock_email_template)
      get :edit, :id => "37", :farm_id => @farm.id
      assigns[:email_template].should equal(mock_email_template)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created email_template as @email_template" do
        EmailTemplate.stub(:new).with({'these' => 'params'}).and_return(mock_email_template(:save => true))
        post :create, :email_template => {:these => 'params'}, :farm_id => @farm.id
        assigns[:email_template].should equal(mock_email_template)
      end

      it "redirects to the created email_template" do
        EmailTemplate.stub(:new).and_return(mock_email_template(:save => true))
        post :create, :email_template => {}, :farm_id => @farm.id
        response.should redirect_to(email_template_url(mock_email_template, :farm_id => assigns[:farm].id))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved email_template as @email_template" do
        EmailTemplate.stub(:new).with({'these' => 'params'}).and_return(mock_email_template(:save => false))
        post :create, :email_template => {:these => 'params'}, :farm_id => @farm.id
        assigns[:email_template].should equal(mock_email_template)
      end

      it "re-renders the 'new' template" do
        EmailTemplate.stub(:new).and_return(mock_email_template(:save => false))
        post :create, :email_template => {}, :farm_id => @farm.id
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested email_template" do
        EmailTemplate.should_receive(:find).with("37").and_return(mock_email_template)
        mock_email_template.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :email_template => {:these => 'params'}, :farm_id => @farm.id
      end

      it "assigns the requested email_template as @email_template" do
        EmailTemplate.stub(:find).and_return(mock_email_template(:update_attributes => true))
        put :update, :id => "1", :farm_id => @farm.id
        assigns[:email_template].should equal(mock_email_template)
      end

      it "redirects to the email_template" do
        EmailTemplate.stub(:find).and_return(mock_email_template(:update_attributes => true))
        put :update, :id => "1", :farm_id => @farm.id
        response.should redirect_to(email_template_url(mock_email_template, :farm_id => assigns[:farm].id))
      end
    end

    describe "with invalid params" do
      it "updates the requested email_template" do
        EmailTemplate.should_receive(:find).with("37").and_return(mock_email_template)
        mock_email_template.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :email_template => {:these => 'params'}, :farm_id => @farm.id
      end

      it "assigns the email_template as @email_template" do
        EmailTemplate.stub(:find).and_return(mock_email_template(:update_attributes => false))
        put :update, :id => "1", :farm_id => @farm.id
        assigns[:email_template].should equal(mock_email_template)
      end

      it "re-renders the 'edit' template" do
        EmailTemplate.stub(:find).and_return(mock_email_template(:update_attributes => false))
        put :update, :id => "1", :farm_id => @farm.id
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested email_template" do
      EmailTemplate.should_receive(:find).with("37").and_return(mock_email_template)
      mock_email_template.should_receive(:destroy)
      delete :destroy, :id => "37", :farm_id => @farm.id
    end

    it "redirects to the email_templates list" do
      EmailTemplate.stub(:find).and_return(mock_email_template(:destroy => true))
      delete :destroy, :id => "1", :farm_id => @farm.id
      response.should redirect_to(email_templates_url :farm_id => assigns[:farm].id)
    end
  end

end
