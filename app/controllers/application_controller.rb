class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|  
    flash[:error] = exception.message
    redirect_to profile_url  
  end  

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end
