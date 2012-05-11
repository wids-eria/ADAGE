class WelcomeController < ApplicationController
  before_filter :authenticate_user!, :only => :my_page
  
  def index
     @users = User.all
     respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @users }
      end
  end

  def my_page
    @users = User.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

end
