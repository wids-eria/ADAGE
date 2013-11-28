class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook


    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)
    sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated

  end

  def google_oauth2
    @user = User.find_for_google_oauth2(request.env["omniauth.auth"], current_user)
    sign_in_and_redirect @user, :event => :authentication
  end
end
