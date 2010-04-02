class FeedbacksController < ApplicationController
  layout false
  skip_before_filter :authenticate
  
  
  def new
    @feedback = Feedback.new    
  end
  
  def create
    
    @feedback = Feedback.new(params[:feedback])

    @feedback.user = "#{current_user.member.first_name} #{current_user.member.last_name}" if current_user && current_user.member

    if @feedback.valid?
      FeedbackMailer.deliver_feedback(@feedback)
      render :status => :created, :text => '<h3>Thank you for your feedback!</h3>'
    else
      @error_message = "Please enter your #{@feedback.subject.to_s.downcase}"
	  
	  # Returns the whole form back. This is not the most effective
      # use of AJAX as we could return the error message in JSON, but
      # it makes easier the customization of the form with error messages
      # without worrying about the javascript.
      render :action => 'new', :status => :unprocessable_entity
    end
    
    
  end
  
end
