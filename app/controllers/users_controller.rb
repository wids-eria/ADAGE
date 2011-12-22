class UsersController < ApplicationController
  skip_authorization_check :only => :authenticate_for_token

  def authenticate_for_token
    @user = User.find_by_email params[:email]
    if @user != nil and @user.valid_password? params[:password]
      @auth_token = @user.authentication_token
      ret = {:session_id => @user.id, :auth_token => @auth_token}
      respond_to do |format|
        format.json {render :json => ret }
        format.xml  {render :xml => ret }
      end
    else
      render :nothing => true, :status => :forbidden
    end
  end
end
