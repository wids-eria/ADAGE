class WelcomeController < ApplicationController
  before_filter :authenticate_user!, :only => :my_page
  
  def index
    if current_user != nil
      if not current_user.roles.where(name: 'tenacity').empty?
        redirect_to '/tenacity'
      end
    end
  end

  def my_page
    render :text => 'woo'
  end
end
