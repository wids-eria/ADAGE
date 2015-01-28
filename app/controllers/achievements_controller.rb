class AchievementsController < ApplicationController
  before_filter :authenticate_user!
  wrap_parameters format: [:json, :xml]
  respond_to :json
  protect_from_forgery except: [:save_stat,:get_stat]

  def save_achievement
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
      stat = Achievement.where(user_id: @user,game_id: @game).first_or_create
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

  def get_achievement
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
      achievement = Achievement.where(user_id: @user,game_id: @game).first

      unless achievement.nil? or achievement.data[params[:key]].nil?
        data = achievement.data[params[:key]]
        status = :ok
      else
        errors << "Achievement Does Not Exist For #{params[:key]}"
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

  def get_achievements
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
      achievement = Achievement.where(user_id: @user,game_id: @game).first

      unless achievement.nil?
        data = achievement.data
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