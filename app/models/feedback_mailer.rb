class FeedbackMailer < ActionMailer::Base
  
  def feedback(feedback)
    @recipients  = ENV['ADMIN_EMAIL']
    @from        = '"Eggbasket Feedback" <noreply@eggbasket.org>'
    @subject     = "[Feedback for YourSite] #{feedback.subject}"
    @sent_on     = Time.now
    @body[:feedback] = feedback    
  end

end
