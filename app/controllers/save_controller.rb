class SaveController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :json, :csv
  protect_from_forgery :except => :save


  def load
    client = Client.where(app_token: params[:app_token]).first

    if client != nil
      save_record = current_user.saves.where(implementation_id: client.implementation.id).first
      if save_record != nil
        @save = save_record.save_game
      end
    end

    respond_with @save
  end

  def save
    error = false
    if params[:save_game] and params[:app_token]
      client = Client.where(app_token: params[:app_token]).first
      if client != nil
        game_save = current_user.saves.find_or_create_by(implementation_id: client.implementation.id)
        game_save.write_attributes(save_game: params[:save_game])
        game_save.user = current_user
        if !game_save.save
          error = true
        end

      else
        error = true
      end
    end

    return_value = {}
    if error
      status = 400
    else
      status = 201
    end
    respond_to do |format|
      format.all { redirect_to :root, :status => status}
    end
  end
end