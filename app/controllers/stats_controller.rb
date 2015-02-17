class StatsController < ApplicationController
  before_filter :authenticate_user!
  wrap_parameters format: [:json, :xml]
  respond_to :json
  protect_from_forgery except: [:save_stat,:save_stats,:get_stat]

  def save_stat
    #Find Game and user through access token
    access_token = AccessToken.where(consumer_secret: params[:access_token]).first

    errors = []
    @game = nil
    unless access_token.nil?
      @game = access_token.client.implementation.game
      @user = access_token.user
    else
      errors << "Invalid Access Token"
      status = 400
    end

    unless access_token.nil? or @game.nil?
      stat = Stat.where(user_id: @user,game_id: @game).first_or_create
      #Set hstore key=>value
      stat.data[params[:key]] = params[:value]

      if stat.save
        status = 201
      else
        status = 400
      end
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

  def save_stats
    #Find Game and user through access token
    access_token = AccessToken.where(consumer_secret: params[:access_token]).first
    errors = []
    @game = nil
    unless access_token.nil?
      @game = access_token.client.implementation.game
      @user = access_token.user
    else
      errors << "Invalid Access Token"
      status = 400
    end

    unless access_token.nil? or @game.nil?
      stats = params[:stats]
      stats.keys.each do |key|

        stat = Stat.where(user_id: @user,game_id: @game).first_or_create

        #Set hstore key=>value
        stat.data[key] = stats[key]

        if stat.save
          status = 201
        else
          status = 400
        end
      end
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

  def clear_stats
    #Find Game and user through access token
    access_token = AccessToken.where(consumer_secret: params[:access_token]).first
    errors = []
    @game = nil
    unless access_token.nil?
      @game = access_token.client.implementation.game
      @user = access_token.user
    else
      errors << "Invalid Access Token"
      status = 400
    end

    unless access_token.nil? or @game.nil?
      stat = Stat.where(user_id: @user,game_id: @game).first

      stat.data = {}
      stat.save
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
    #Find Game and user through access token
    access_token = AccessToken.where(consumer_secret: params[:access_token]).first

    errors = []
    @game = nil
    unless access_token.nil?
      @game = access_token.client.implementation.game
      @user = access_token.user
    else
      errors << "Invalid Access Token"
      status = 400
    end

    data = nil
    unless access_token.nil? or @game.nil?
      stat = Stat.where(user_id: @user,game_id: @game).first

      unless stat.nil? or stat.data[params[:key]].nil?
        data = stat.data[params[:key]]
        status = :ok
      else
        errors << ["Stat Does Not Exist For #{params[:key]}"]
        status = 400
      end
    end

    respond_to do |format|
      format.json {
        render json: {
          data: data,
          errors: errors
        },
        status: status
      }
    end
  end

  def get_stats
    #Find Game and user through access token
    access_token = AccessToken.where(consumer_secret: params[:access_token]).first

    errors = []
    @game = nil
    unless access_token.nil?
      @game = access_token.client.implementation.game
      @user = access_token.user
    else
      errors << "Invalid Access Token"
      status = 400
    end

    data = nil
    unless access_token.nil? or @game.nil?
      stat = Stat.where(user_id: @user,game_id: @game).first

      unless stat.nil?
        data = stat.data
        puts data
        status = :ok
      end
    end

    respond_to do |format|
      format.json {
        render json: {
          data: data,
          errors: errors
        },
        status: status
      }
    end
  end

end