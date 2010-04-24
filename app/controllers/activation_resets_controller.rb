class ActivationResetsController < ApplicationController
  skip_before_filter :authenticate
  before_filter :require_no_user

  def new
    render
  end

  def create
    @user = User.find_by_email(params[:email])
    if @user

      if @user.active
        flash[:notice] = "Hmm, It looks like your account is already active. Perhaps try resetting your password?"
        redirect_to login_url
      else
        @user.deliver_welcome_and_activation!
        flash[:notice] = "Woohoo! Instructions to activate your account have been emailed to you. " +
        "Please check your email."
        redirect_to login_url
      end
    else
      flash[:notice] = "Hmm, we didn't find an existing account with that email. Do you perhaps use a different address?"
      render :action => :new
    end
  end

end
