class ApplicationMailer < ActionMailer::Base
  #
  # Delivers an email template to one or more receivers
  #
  def email_template(to, email_template, options = {})
    subject email_template.render_subject(options)
    recipients to
    from email_template.from
    sent_on Time.now
    cc options['cc'] if options.key?('cc')
    bcc options['bcc'] if options.key?('bcc')
    body email_template.render_body(options)
  end
end
