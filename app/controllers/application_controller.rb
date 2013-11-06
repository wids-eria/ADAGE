class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :oauth_access_token

  rescue_from CanCan::AccessDenied do |exception|  
    flash[:error] = exception.message
    redirect_to profile_url  
  end  

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  protected

  def oauth_access_token
    #check the header for use of an access token
    authorization = request.env["HTTP_AUTHORIZATION"]
    access_token = nil
    if authorization != nil
      token = authorization.split().last
      access_token = AccessToken.where(consumer_secret: token).first
    else
      #check for a param with the token
      puts params[:authorization_token]
      authorization = params[:authorization_token]
      if authorization != nil
        access_token = AccessToken.where(consumer_secret: authorization).first
      end
    end


    if access_token != nil
      sign_in access_token.user
    end

  end


end
