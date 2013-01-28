class GamesController < ApplicationController
  load_and_authorize_resource  
  before_filter :authenticate_user!

  def show
    @game = Game.find(params[:id])
    @users = User.select{ |user| user.role?(ParticipantRole.where(game_id: @game.id).first) }
    @average_time = 0
    if @users.count > 0
      @users.each do |user| 
          if user.data.count >= 2
            @average_time +=  user.data.last.created_at - user.data.first.created_at
          end
      end
      @average_time = @average_time/@users.count
    end

  end

  def search_users
    @game = Game.find(params[:id])
    if params[:consented] == true
      @user = User.where(consented: true)
    end
    @user = User.select{ |user| user.data.where(game_name: @game.name) }
  
  end

  def index
    @games = Array.new 
    Game.all.each do |game|
      if can? :read, game
        @games << game
      end
    end
  end

  def new
    @game = Game.new
  end

  def create
    game = Game.new(params[:game])
    if game.save
      flash[:notice] = 'Game Added'
    else
      flash[:error] = 'Game name is not unique'
    end
    redirect_to games_path
  end

  def edit
    @game = Game.find(params[:id])
  end

end
