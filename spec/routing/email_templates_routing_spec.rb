require 'spec_helper'

describe EmailTemplatesController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/email_templates" }.should route_to(:controller => "email_templates", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/email_templates/new" }.should route_to(:controller => "email_templates", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/email_templates/1" }.should route_to(:controller => "email_templates", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/email_templates/1/edit" }.should route_to(:controller => "email_templates", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/email_templates" }.should route_to(:controller => "email_templates", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/email_templates/1" }.should route_to(:controller => "email_templates", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/email_templates/1" }.should route_to(:controller => "email_templates", :action => "destroy", :id => "1") 
    end
  end
end
