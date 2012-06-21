class OauthController < ApplicationController
  before_filter :authenticate_user!, except: [:access_token]

  def authorize
    application = Client.where(app_token: params[:client_id]).first
    access_token = current_user.access_tokens.create({client: application})
    redirect_to access_token.redirect_uri_for(params[:redirect_uri])
  end

  def authenticate_for_token
    @user = User.find_by_email params[:email].downcase
    ret = {}
    if @user != nil and @user.valid_password? params[:password]
      @auth_token = @user.authentication_token
      ret = {:session_id => 'remove me', :auth_token => @auth_token}
      respond_to do |format|
        format.json {render :json => ret, :status => :created }
        format.xml  {render :xml => ret, :status => :created }
      end
    else
      ret = {:error => "Invalid email or password"}
      respond_to do |format|
        format.json {render :json => ret, :status => :unauthorized }
        format.xml  {render :xml => ret, :status => :unauthorized }
      end
    end
  end

  def access_token
    application = Client.where(app_token: params[:client_id], app_secret: params[:client_secret]).first
    if application.nil?
      render :json => {:error => "Could not find application." }
      return
    end

    access_token = AccessToken.authenticate(params[:code], application.id)
    render :json => {:access_token => access_token }
  end

  def failure
    render :text => "ERROR: #{params[:message]}"
  end

  def user
    hash = {
      provider: 'ada',
      uid: current_user.id.to_s,
      info: {
        email: current_user.email
      }
    }

    render :json => hash.to_json
  end

end
