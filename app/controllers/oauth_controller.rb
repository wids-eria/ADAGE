class OauthController < ApplicationController
  before_filter :authenticate_user!, except: [:client_side_create_user, :access_token, :user, :authorize_unity, :authorize_unity_fb, :guest, :authorize_brainpop]
  skip_before_filter :verify_authenticity_token, :only => [:access_token, :user]

  def authorize
    application = Client.where(app_token: params[:client_id]).first
    access_token = current_user.access_tokens.create({client: application})
    redirect_to access_token.redirect_uri_for(params[:redirect_uri]+"?&state=#{params[:state]}")
  end

  def access_token
    application = Client.where(app_token: params[:client_id], app_secret: params[:client_secret]).first
    if application.nil?
      render :json => {:error => "Could not find application." }, :status => 401
      return
    end

    access_token = AccessToken.authenticate(params[:code], application.id)
    render :json => {:access_token => access_token.consumer_secret  }
  end


  def client_side_create_user
      application = Client.where(app_token: params[:client_id], app_secret: params[:client_secret]).first
      if application.nil?
        render :json => {:error => "Could not find application." }, :status => 401
        return
      end

      user = User.with_login(params[:player_name]).first
      if user != nil
        user = User.with_login(params[:email]).first
        if user != nil and user.valid_password? params[:password]
          sign_in user
        else
          render :json => {:error => "Incorrect player name or password." }, :status => 401
          return
        end
      else
        user = User.new(player_name: params[:player_name], email: params[:email], password: params[:password], password_confirm: params[:password_confirm])
        unless user.save
           render :json => {:error => user.errors.full_messages }, :status => 401
           return
        end
        sign_in user
      end


    access_token = current_user.access_tokens.find_or_create_by_user_id(current_user.id, {client: application})
    render :json => {:access_token => access_token.consumer_secret }


  end

  def authorize_unity
    user = User.with_login(params[:email]).first
    if user != nil and user.valid_password? params[:password]
      sign_in user
    else
      render :json => {:error => "Incorrect player name or password." }, :status => 401
      return
    end

    application = Client.where(app_token: params[:client_id], app_secret: params[:client_secret]).first
    if application.nil?
      render :json => {:error => "Could not find application." }, :status => 401
      return
    end

    access_token = current_user.access_tokens.find_or_create_by_user_id(current_user.id, {client: application})
    render :json => {:access_token => access_token.consumer_secret }
  end

  def authorize_unity_fb
    parsed = JSON.parse(request.env["HTTP_OMNIAUTH.AUTH"])
    auth = OmniAuth::AuthHash.new(parsed)

    puts auth.inspect
    puts auth["info"]

    user = User.find_for_facebook_oauth(auth, current_user)
    if user.nil?
      render :json => {:error => "Player not found." }, :status => 401
      return
    end

    application = Client.where(app_token: params[:client_id], app_secret: params[:client_secret]).first
    if application.nil?
      render :json => {:error => "Could not find application." }, :status => 401
      return
    end


    access_token = user.access_tokens.find_or_create_by_user_id(user.id, {client: application})
    render :json => {:access_token => access_token.consumer_secret}

  end

  def authorize_brainpop

    user = User.find_for_brainpop_auth(params[:player_id], current_user)
    if user.nil?
      render :json => {:error => "Player not found." }, :status => 401
      return
    end

    application = Client.where(app_token: params[:client_id], app_secret: params[:client_secret]).first
    if application.nil?
      render :json => {:error => "Could not find application." }, :status => 401
      return
    end


    access_token = user.access_tokens.find_or_create_by_user_id(user.id, {client: application})
    render :json => {:access_token => access_token.consumer_secret}


  end

  def failure
    render :text => "ERROR: #{params[:message]}"
  end

  def adage_user
    unless current_user
      render :json => {:error => "Player not found." }, :status => 401
    end

    hash = {
      provider: 'ADAGE',
      uid: current_user.id.to_s,
      player_name: current_user.player_name,
      email: current_user.email,
      guest: current_user.guest
    }
    respond_to do |format|
      format.json { render :json => hash.to_json }
    end

  end

  #This call is being depricated in preference of adage_user
  def user
    access_token = AccessToken.where(consumer_secret: params[:oauth_token]).first
    user = access_token.user
    redirect_to :failure unless user
    hash = {
      provider: 'ada',
      uid: user.id.to_s,
      info: {
        email: user.email,
        player_name: user.player_name,

        #This is stupid but here for backwards compatability
        auth: user.authentication_token,
      }
    }

    unless params[:group].nil?
      user.add_to_group(params[:group])
    end

    respond_to do |format|
      format.json { render :json => hash.to_json }
    end
  end


  def guest
    application = Client.where(app_token: params[:client_id], app_secret: params[:client_secret]).first

    unless application.nil?
      user =  User.create_guest
      access_token =  user.access_tokens.create({client: application})

      redirect_to :failure unless user

      #If group code is present add the player to the group
      unless params[:group].nil?
        user.add_to_group(params[:group])
      end

      sign_in user

      render :json => {:access_token => access_token.consumer_secret}

    else
      render :json => {:error => "Could not find application." }, :status => 401
      return
    end
  end

end
