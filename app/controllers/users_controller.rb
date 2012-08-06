class UsersController < ApplicationController
  respond_to :html, :json

  before_filter :authenticate_user!, except: [:authenticate_for_token]

  def index
    @users = User.page params[:page]
    authorize! :read, @users
    respond_to do |format|
      format.html { @users = User.page params[:page] }
      format.json { render :json => User.all }
    end
  end

  def authenticate_for_token
    @user = User.find_by_email params[:email].downcase
    ret = {}
    if @user != nil and @user.valid_password? params[:password]
      @auth_token = @user.authentication_token
      ret = {:session_id => 'remove me', :auth_token => @auth_token}
      respond_to do |format|
        format.json {render :json => ret, :status => :created }
        format.xml  {render :xml => ret, :status => :created }
      end
    else
      ret = {:error => "Invalid email or password"}
      respond_to do |format|
        format.json {render :json => ret, :status => :unauthorized }
        format.xml  {render :xml => ret, :status => :unauthorized }
      end
    end
  end

  def new_sequence
    @user_sequence = UserSequence.new
  end

  def create_sequence
    @user_sequence = UserSequence.new params[:user_sequence]

    if @user_sequence.valid?

      @user_sequence.create_users!

      respond_to do |format|
        format.html { redirect_to users_path }
        format.json { render :json => @user_sequence, :status => :created }
      end
    else
      respond_to do |format|
        format.html { render 'new_sequence' }
        format.json { render :json => @user_sequence }
      end
    end
  end

  def get_data_by_user
    @data = AdaData.where(user_id: params[:user_id]).where(GameName: params[:game_name])
    authorize! :read, @data
    respond_to do |format|
      format.json { render :json => @data }
    end
  end

  def get_kodu_activity
    @data = AdaData.where(user_id: params[:user_id]).where(gameName: 'kodu').where(:created_at.gte => params[:start_time]).where(:created_at.lt => params[:end_time]).where(:name => 'SetGameMode', :data.nin => ['HomeMenu', 'ToolMenuHomeMenu', 'GamepadEditObjectFocus', 'GamepadEditObject', 'ToolMenuEditObject'])
    authorize! :read, @data
    respond_to do |format|
      format.json { render :json => @data }
    end
  end

  def get_kodu_level_info
    @data = AdaData.where(user_id: params[:user_id]).where(gameName: 'kodu').where(data: 'MainMenu')
    authorize! :read, @data
    respond_to do |format|
      format.json { render :json => @data }
    end
  end

  protected

  def application
    @application ||= Client.where(app_token: params[:client_id]).first
  end
end
