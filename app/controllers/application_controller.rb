# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  rescue_from 'Acl9::AccessDenied', :with => :access_denied
  
  before_filter :authenticate
  before_filter :set_farm

  helper_method :current_user

  ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
    if instance.error_message.kind_of?(Array)
      %(#{html_tag}<span class="validation-error">&nbsp;
        #{instance.error_message.join(', ')}</span>)
    else
      %(#{html_tag}<span class="validation-error">&nbsp;
        #{instance.error_message}</span>)
      end
  end


  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined? @current_user
    @current_user = current_user_session && current_user_session.record
  end

  def set_farm
    @farm = Farm.find(params[:farm_id]) if params[:farm_id]
  end

  def authenticate
    unless current_user
      flash[:notice] = "You must log in to access this page"
      redirect_to login_url
      return false
    end
  end

  def require_no_user
    if current_user

      @user_session = UserSession.find
      @user_session.destroy
      flash[:notice] = "You must be logged out to access this page"
      redirect_to root_url
      return false
    end
  end
  

  def access_denied
    if current_user
      render :acctemplate => 'home/access_denied'
    else
      flash[:notice] = 'Access denied. Try to log in first.'
      redirect_to login_path
    end
  end
end
