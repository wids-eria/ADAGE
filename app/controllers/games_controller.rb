class GamesController < ApplicationController
  before_filter :authenticate_user!

  def show
    @game = Game.find(params[:id])
    @users = User.select{ |user| user.data.where(gameName: @game.name).count > 0 }
  end

  def index
    @games = Game.page params[:page]
    respond_to do |format|
      format.html { @games }
      format.json { render :json => Games.all }
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
