class PasswordResetsController < ApplicationController
  skip_before_filter :authenticate
  before_filter :require_no_user
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]

  def new
    render
  end

  def create
    @user = User.find_by_email(params[:email])
    if @user
      @user.deliver_password_reset_instructions!
      flash[:notice] = "Instructions to reset your password have been emailed to you. " +
      "Please check your email."
      redirect_to login_url
    else
      flash[:notice] = "No user was found with that email address"
      render :action => :new
    end
  end

  def edit
    render
  end

  
  def update
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]

    if params[:user][:password] != '' && @user.save 
      flash[:notice] = "Password successfully updated"
      redirect_to root_url
    else
      if params[:user][:password] == '' && params[:user][:password_confirmation] == ''
        flash[:notice] = "Passwords cannot be blank"
      end
      User.disable_perishable_token_maintenance(true)
      @user.update_attribute(:perishable_token, params[:id]);
      render :action => :edit
      User.disable_perishable_token_maintenance(false)
    end
  end

  private
  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])

    unless @user
      flash[:notice] = "We're sorry, but we could not locate your account. " +
      "If you are having issues try copying and pasting the URL " +
      "from your email into your browser or restarting the " +
      "reset password process."

      redirect_to root_url
    end
  end


end
