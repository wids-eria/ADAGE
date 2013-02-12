class GamesController < ApplicationController
  load_and_authorize_resource  
  before_filter :authenticate_user!

  def show
    @game = Game.find(params[:id])
    @users = RolesUser.where(role_id: @game.participant_role.id).collect{ |ru| ru.user}
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
    @users = User.player_name_matches(params[:player_name])
    if params[:consented] == true
      @users = @users.where(consented: true)
    end 
    @users = @users.select{ |user| user.data.where(gameName: @game.name).count > 0}
    puts @users.inspect
  end

  def admin
    @games = Game.all
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
