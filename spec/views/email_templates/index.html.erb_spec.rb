require 'spec_helper'

describe "/email_templates/index.html.erb" do
  include EmailTemplatesHelper

  before(:each) do
    assigns[:farm] = @farm = stub_model(Farm)    
    assigns[:email_templates] = [
      stub_model(EmailTemplate,
        :subject => "value for subject",
        :from => "value for from",
        :bcc => "value for bcc",
        :cc => "value for cc",
        :body => "value for body"
      ),
      stub_model(EmailTemplate,
        :subject => "value for subject",
        :from => "value for from",
        :bcc => "value for bcc",
        :cc => "value for cc",
        :body => "value for body"
      )
    ]
  end

  it "renders a list of email_templates" do
    render
    response.should have_tag("tr>td", "value for subject".to_s, 2)
    response.should have_tag("tr>td", "value for from".to_s, 2)
    response.should have_tag("tr>td", "value for bcc".to_s, 2)
    response.should have_tag("tr>td", "value for cc".to_s, 2)
    response.should have_tag("tr>td", "value for body".to_s, 2)
  end
end
