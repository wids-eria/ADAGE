class GamesController < ApplicationController
  respond_to :html, :json, :csv
  load_and_authorize_resource
  before_filter :authenticate_user!
  layout 'blank'

  def show
    @game = Game.find(params[:id])
    @users = @game.users

    @log_count = AdaData.with_game(@game.name).only(:_id).size
    @num_users = AdaData.with_game(@game.name).only(:user_id).distinct(:user_id).size

     session[:graph_params] = nil
  end


  def developer_tools
    @game = Game.find(params[:id])
    @users = @game.users
  end

  def logger
    @game = Game.find(params[:id])

    params[:start] = params[:start].to_i/1000
    start_time = DateTime.strptime(params[:start].to_s, "%s").to_time
    puts start_time
    logs = AdaData.with_game(@game.name).where(:created_at.gt => start_time).all
    respond_to do |format|
      format.json {
        render json: logs.to_json
      }
    end
  end

  def sync_time
    respond_with Time.now
  end

  def researcher_tools
    @game = Game.find(params[:id])
    @users = @game.users

    @users.each do |user|
      lastlog = AdaData.with_game(@game.name).only(:user_id,:timestamp).order_by(:timestamp.asc).where(user_id: user[:id]).last
      unless lastlog.nil?
        user.instance_variable_set("@last_playtime", lastlog[:timestamp].to_i)
      else
        user.instance_variable_set("@last_playtime", lastlog)
      end
    end
  end

  def statistics
    @game = Game.find(params[:id])

    @log_count = AdaData.with_game(@game.name).only(:_id).size
    @num_users = AdaData.with_game(@game.name).only(:user_id).distinct(:user_id).size
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


  def select_graph

    @game = Game.find(params[:id])

    @implementations = @game.implementations
    @ranges = ['hour','day','week','month','all']
    @graph_types = ['value over time', 'session times', 'key count']


    if session[:graph_params].nil?
      session[:graph_params] = GraphParams.new
    end

    @graph_params = session[:graph_params]



    puts @graph_params.app_token

    if params[:app_token] != nil
      @graph_params.app_token = params[:app_token]
    end

    if params[:graph_type] != nil
      #When changing the graph type we reset all the graph params
      @graph_params = GraphParams.new
      @graph_params.graph_type = params[:graph_type]
    end

    if params[:time_range] != nil
      @graph_params.time_range = params[:time_range]
    end

    if params[:game_id] != nil
      if params[:game_id].include?('All Games')
        @graph_params.game_id = nil
      else
        @graph_params.game_id = params[:game_id]
      end
    end

    if params[:key] != nil
      @graph_params.key = params[:key]
    end

    if params[:field_name] != nil
      index = params[:field_depth].to_i
      @graph_params.field_names[index] = params[:field_name]
      @graph_params.field_names = @graph_params.field_names.drop(@graph_params.field_names.count - (index+1))
    end

    @keys = Array.new
    @fields = Hash.new
    @game_ids = Array.new
    if @graph_params.app_token != nil



      if @graph_params.time_range == nil
        @graph_params.time_range = 'hour'
      end

      @game_ids = AdaData.with_game(@game.name).where(:timestamp.gt => time_range_to_epoch(@graph_params.time_range)).distinct(:game_id)
      @game_ids << 'All Games'


      @keys = AdaData.with_game(@game.name).distinct(:key)

      if @graph_params.key != nil


        @fields = add_field_names(0, AdaData.with_game(@game.name).where(key: @graph_params.key).first.attributes, @fields, @graph_params.field_names)

      end


    end

    @rickshaw_url = @graph_params.to_rickshaw_url
    @json_url = @graph_params.to_json_url
    @csv_url = @graph_params.to_csv_url

    session[:graph_params] = @graph_params

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
    @users = @users.select{ |user| user.data(@game.name).count > 0}
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

  def clear_data
    if !Rails.env.production?
      @game = Game.find(params[:id])
      if current_user.admin?
         AdaData.with_game(@game.name).delete_all
      end
      redirect_to developer_tools_game_path(@game)
    end
  end
end
