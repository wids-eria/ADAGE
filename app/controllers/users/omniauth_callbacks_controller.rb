class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook

    puts '*'*20
    puts request.env["omniauth.auth"].inspect
    puts '*'*20

    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)
    sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated

  end

end
