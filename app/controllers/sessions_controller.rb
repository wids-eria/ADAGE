class SessionsController < ApplicationController
  skip_authorization_check
  
  
  def create 
    
    puts request.env['omniauth.auth']

  end

end
