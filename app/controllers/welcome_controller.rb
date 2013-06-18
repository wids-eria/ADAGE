class WelcomeController < ApplicationController
  before_filter :authenticate_user!, :only => :my_page

  def index
    if user_signed_in?
      redirect_to profile_url
    else
      redirect_to new_user_session_url
    end
  end

  def profile
    render :index
  end
end
