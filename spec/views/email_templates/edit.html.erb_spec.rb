require 'spec_helper'

describe "/email_templates/edit.html.erb" do
  include EmailTemplatesHelper

  before(:each) do
    assigns[:farm] = @farm = stub_model(Farm)
    assigns[:email_template] = @email_template = stub_model(EmailTemplate,
      :new_record? => false,
      :subject => "value for subject",
      :from => "value for from",
      :bcc => "value for bcc",
      :cc => "value for cc",
      :body => "value for body"
    )
  end

  it "renders the edit email_template form" do
    render

    response.should have_tag("form[action=#{email_template_path(@email_template)}][method=post]") do
      with_tag('input#email_template_subject[name=?]', "email_template[subject]")
      with_tag('input#email_template_from[name=?]', "email_template[from]")
      with_tag('input#email_template_bcc[name=?]', "email_template[bcc]")
      with_tag('input#email_template_cc[name=?]', "email_template[cc]")
      with_tag('textarea#email_template_body[name=?]', "email_template[body]")
    end
  end
end
