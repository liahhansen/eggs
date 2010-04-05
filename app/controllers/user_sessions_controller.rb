class UserSessionsController < ApplicationController

  skip_before_filter :authenticate    

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      if(current_user.has_role?(:admin))
        redirect_to farms_url
      else
        redirect_to current_user
      end
    else
      render :action => 'new'
    end
  end

  def destroy
    @user_session = UserSession.find
    @user_session.destroy if @user_session
    flash[:notice] = "Successfully logged out."
    redirect_to root_url
  end

end
