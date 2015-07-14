class ConfigController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :json, :csv
  protect_from_forgery :except => :save 


  def show
    @config = ConfigData.find(id: params[:id])
    respond_with @config
  end

  def load
    client = Client.where(app_token: params[:app_token]).first
    if client != nil

      config_record = client.implementation.config
      if config_record != nil
        @config = config_record.config_file
      end
    end

    respond_with @config
  end

  def save 
    error = false
    errors = []
    if params[:config_file] and params[:app_token]
      client = Client.where(app_token: params[:app_token]).first
      if client != nil
        config = ConfigData.find_or_create_by(implementation_id: client.implementation.id)
        config.write_attributes(config_file: params[:config_file])

        if !config.save
          error = true
        end

      else
        errors << "Invalid App Token"
        error = true
      end
    else
      if params[:app_token].nil?
        errors << "Missing App Token"
      end
    end

    return_value = {}
    if error
      status = 400 
    else
      status = 201 
    end
    respond_to do |format|
      format.all {
        render json: {
          errors: errors
        },
        status: status;
      } 
    end
  end

  
end
