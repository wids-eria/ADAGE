class SessionsController < ApplicationController
  skip_authorization_check
  
  
  def create 
   
    puts '*'*20 
    puts request.env['omniauth.auth']
    puts '*'*20 
    redirect_to :root

  end

end
