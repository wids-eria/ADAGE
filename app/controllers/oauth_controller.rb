class OauthController < ApplicationController
  before_filter :authenticate_user!, except: [:access_token, :user]
  skip_before_filter :verify_authenticity_token, :only => [:access_token, :user]

  def authorize
    application = Client.where(app_token: params[:client_id]).first
    access_token = current_user.access_tokens.create({client: application})
    redirect_to access_token.redirect_uri_for(params[:redirect_uri])
  end

  def access_token
    application = Client.where(app_token: params[:client_id], app_secret: params[:client_secret]).first
    if application.nil?
      render :json => {:error => "Could not find application." }
      return
    end

    access_token = AccessToken.authenticate(params[:code], application.id)
    render :json => {:access_token => access_token.consumer_secret  }
  end

  def failure
    render :text => "ERROR: #{params[:message]}"
  end

  def user
    access_token = AccessToken.where(consumer_secret: params[:oauth_token]).first
    user = access_token.user
    redirect_to :failure unless user
    hash = {
      provider: 'ada',
      uid: user.id.to_s,
      info: {
        email: user.email,
        username: user.player_name
      }
    }

    respond_to do |format|
      format.json { render :json => hash.to_json }
    end
  end

end
