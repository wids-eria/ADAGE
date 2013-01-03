class WelcomeController < ApplicationController
  before_filter :authenticate_user!, :only => :my_page
  
  def index
    if current_user != nil
      if current_user.role?(Role.find_by_name('admin'))
        render 'admin'
      elsif current_user.researcher_role?
        render 'researcher'
      else
        render 'player'
      end
    end
  end

  def my_page
    render :text => 'woo'
  end
end
