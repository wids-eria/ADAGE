class GvController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :json, :csv

  def save 
    error = false
    if params[:game_version_data] and params[:app_token]
      client = Client.where(app_token: params[:app_token]).first
      if client != nil
        version_data = GameVersionData.where(implementation_id: client.implementation.id).first
        authorize! :manage, client.implementation.game 
        if version_data != nil
          message = "Game version data already exists."
          error = true
        else 
          version_data = GameVersionData.create(params[:game_version_data])
          version_data.implementation = client.implementation
          version_data.game = client.implementation.game
          if !version_data.save
            message = version_data.errors.full_messages 
            error = true
          end
        end

      else
        message = "Could not find client application"
        error = true
      end
    end


    if error
      status = 401 
    else
      status = 201 
    end

    respond_to do |format|
      format.json { render :json => {:error => message}, :status => status }
      format.html {
              flash[:error] = message 
              redirect_to :root  
            }
    end

  end


  def delete
    error = false
    if params[:app_token]
      client = Client.where(app_token: params[:app_token]).first
      if client != nil
        authorize! :manage, client.implementation.game 
        version_data = GameVersionData.where(implementation_id: client.implementation.id).first
        if version_data != nil
          version_data.delete  
        end
      else
        message = "Could not find client application"
        error = true
      end
    end

    if error
      status = 401 
    else
      status = 201 
    end

    respond_to do |format|
      format.json { render :json => {:error => message}, :status => status }
      format.html {
              flash[:error] = message 
              redirect_to :root, :status => status 
            }
    end
  end

  def show
    @version_data = nil
    if params[:app_token]
      client = Client.where(app_token: params[:app_token]).first
      if client != nil
        @version_data = GameVersionData.where(implementation_id: client.implementation.id).first
        authorize! :read, client.implementation.game
      end

    end
    if @version_data != nil
      respond_with @version_data
    end
  end  


end

