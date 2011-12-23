class UsersController < ApplicationController
  def authenticate_for_token
    @user = User.find_by_email params[:email]
    ret = {}
    if @user != nil and @user.valid_password? params[:password]
      @auth_token = @user.authentication_token
      ret = {:session_id => @user.id.to_s, :auth_token => @auth_token}
      respond_to do |format|
        format.json {render :json => ret, :status => :created }
        format.xml  {render :xml => ret, :status => :created }
      end
    else
      ret = {:errors => "Invalid email or password"}
      respond_to do |format|
        format.json {render :json => ret, :status => :unauthorized }
        format.xml  {render :xml => ret, :status => :unauthorized }
      end
    end
  end
end
