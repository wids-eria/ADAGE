class UsersController < ApplicationController
  respond_to :html, :json

  before_filter :authenticate_user!

  def index
    @users = User.page params[:page]
    authorize! :read, @users
    respond_to do |format|
      format.html { @users = User.page params[:page] }
      format.json { render :json => User.all }
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

  def get_data
    @data = AdaData.where(user_id: params[:user_id]).where(gameName: "APA:Tracts")
    respond_to do |format|
      format.json { render :json => @data }
    end
  end

  protected

  def application
    @application ||= Client.where(app_token: params[:client_id]).first
  end
end
