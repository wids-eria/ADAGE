class GamesController < ApplicationController
  respond_to :html, :json, :csv
  load_and_authorize_resource
  before_filter :authenticate_user!
  layout 'blank'

  def show
    @game = Game.find(params[:id])
    @users = @game.users
  end
  

  def developer_tools
    @game = Game.find(params[:id])
    @users = @game.users
  end

  def researcher_tools
    @game = Game.find(params[:id])
    @users = @game.users
  end



  def statistics
    @game = Game.find(params[:id])
    @logs = AdaData.where(gameName: @game.name)
    @num_users = @logs.distinct(:user_id).count
  end

  def sessions
    @game = Game.find(params[:id])
    @users = @game.users
    
    redirect_to session_logs_data_path(game_id: params[:id], user_ids: @game.user_ids) 
  end

  def contexts
    @game = Game.find(params[:id])
    @users = @game.users
    
    redirect_to context_logs_data_path(game_id: params[:id], user_ids: @game.user_ids) 
  end


  def select_graph_params
    @game = Game.find(params[:id]) 
    @data = AdaData.where(gameName: @game.name)
    @types = @data.distinct(:key)
    if params[:graph_params] != nil
      @graph_params = GraphParams.new(params[:graph_params])
    else
      @graph_params = GraphParams.new
    end

    @values = Array.new
    if @graph_params.key != nil
      @values = @data.where(key: @graph_params.key).last.attributes.keys
    end 
    

  end

  def value_over_time
    
    @game = Game.find(params[:id])
    @players = Array.new
    #@game.users.each do |user|
     # user_data = user.data.where(
  
  
  end

  def search_users
    @game = Game.find(params[:id])
    @user_search = UserSearch.new params[:user_search]
    @users = User.player_name_matches(@user_search.substring)
    if @user_search.consented == '1'
      @users = @users.where(consented: true)
    end
    @users = @users.select{ |user| user.data.where(gameName: @game.name).count > 0}
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
    @game = Game.new(params[:game])
    if @game.save
      flash[:notice] = 'Game Added'
      #give the developer who created the game a developer role for the game
      current_user.roles << @game.developer_role 
    else
      flash[:error] = 'Game name is not unique'
    end
    redirect_to games_path
  end

  def edit
    @game = Game.find(params[:id])
  end
end
