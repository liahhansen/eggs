class ActivationsController < ApplicationController
  skip_before_filter :authenticate

  def new
    @user = User.find_using_perishable_token(params[:activation_code], 1.week) || (raise Exception)
    raise Exception if @user.active?
  end

  def create
    @user = User.find(params[:id])

    raise Exception if @user.active?

    if @user.activate!
      @user.deliver_activation_confirmation!
      redirect_to root_url
    else
      render :action => :new
    end
  end
  
  def claim
    
  end

end
