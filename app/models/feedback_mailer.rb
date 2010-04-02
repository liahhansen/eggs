class FeedbackMailer < ActionMailer::Base
  
  def feedback(feedback)
    @recipients  = 'kathryn@kathrynaaker.com'
    @from        = '"Eggbasket Feedback" <noreply@eggbasket.org>'
    @subject     = "[Feedback for YourSite] #{feedback.subject}"
    @sent_on     = Time.now
    @body[:feedback] = feedback    
  end

end
