class GamesController < ApplicationController
  respond_to :html, :json
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


end
