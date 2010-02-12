class HomeController < ApplicationController
  def index
    if current_user
      if current_user.has_role? :admin
        redirect_to farms_url
      else
        redirect_to current_user
      end
    end
  end
end