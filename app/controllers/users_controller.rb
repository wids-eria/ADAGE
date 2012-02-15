class UsersController < ApplicationController
  respond_to :html, :json

  def authenticate_for_token
    @user = User.find_by_email params[:email]
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

  def index
    @users = User.page params[:page]
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
end
