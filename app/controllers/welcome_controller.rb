class WelcomeController < ApplicationController
  before_filter :authenticate_user!, :only => :my_page
  
  def index
  end

  def my_page
    render :text => 'woo'
  end
end
