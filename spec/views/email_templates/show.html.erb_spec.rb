require 'spec_helper'

describe "/email_templates/show.html.erb" do
  include EmailTemplatesHelper
  before(:each) do
    assigns[:farm] = @farm = stub_model(Farm)    
    assigns[:email_template] = @email_template = stub_model(EmailTemplate,
      :subject => "value for subject",
      :from => "value for from",
      :bcc => "value for bcc",
      :cc => "value for cc",
      :body => "value for body"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ subject/)
    response.should have_text(/value\ for\ from/)
    response.should have_text(/value\ for\ bcc/)
    response.should have_text(/value\ for\ cc/)
    response.should have_text(/value\ for\ body/)
  end
end
