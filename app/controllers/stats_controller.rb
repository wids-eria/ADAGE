class StatsController < ApplicationController
  #before_filter :authenticate_user!
  wrap_parameters format: [:json, :xml]
  respond_to :json
  protect_from_forgery except: [:save_stat,:get_stat]

  def save_stat

    #Find Game through app token
    client = Client.where(app_token: params[:app_token]).first
    @game = nil
    unless client.nil?
      @game = client.implementation.game
    end

    @user = User.where(id:params[:user_id]).first

    errors = []
    unless @user.nil? or @game.nil?
      stat = Stat.first_or_create(user_id: @user,game_id: @game)

      #Set hstore key=>value
      stat.data[params[:key]] = params[:value]

      if stat.save
        status = 201
      else
        status = 400
      end
    else
      if @user.nil?
        errors << "Invalid User"
      end

      if @game.nil?
        errors << "No Game found for App Token"
      end

      status = 400
    end

    respond_to do |format|
      format.json {
        render json: {
          errors: errors
        },
        status: status;
      }
    end
  end

  def get_stat
    #Find Game through app token
    client = Client.where(app_token: params[:app_token]).first
    @game = nil
    unless client.nil?
      @game = client.implementation.game
    end

    @user = User.where(id:params[:user_id]).first

    unless @user.nil? or @game.nil?
      stat = Stat.where(user_id: @user,game_id: @game).first

      if stat.data[params[:key]]
        data = stat.data[params[:key]]
      end
    end

    respond_to do |format|
      format.json {
        render json: {
          data: data,
        },
        status: :ok
      }
    end
  end

end