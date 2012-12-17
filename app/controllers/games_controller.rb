class GamesController < ApplicationController
  load_and_authorize_resource  
  before_filter :authenticate_user!

  def show
    @game = Game.find(params[:id])
    @users = User.select{ |user| user.data.where(gameName: @game.name).count > 0 }
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
