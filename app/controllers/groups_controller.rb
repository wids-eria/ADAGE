class GroupsController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource :only => :playsquads
  before_filter :authenticate_user!
  layout 'blank'

  def index
    @groups = Group.all
    @organizations = current_user.organizations

    if current_user.admin?
      @organizations = Organization.all
    end
  end

  def show
    @group = Group.find(params[:id])
    text = ActiveSupport::JSON.encode({ group: @group.code })
    @qr = qrcode(text)
    @users = User.select("id,player_name").order(:player_name).page(params[:page])
  end

  def edit
    @game = Game.find(params[:id])
    @org  = @game.organization
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    if @group.update_attributes params[:group]
      flash[:notice] = 'Group Updated'
      redirect_to @group
    else
      render :edit
    end
  end

  def new
    @org = Organization.find(params[:organization])
    authorize! :manage, @org
    @group = Group.new(params[:group])
  end

  def create
    @org = Organization.find(params[:group][:organization_id])
    authorize! :manage, @org
    @group = Group.new(params[:group])
    if @group.save
      flash[:notice] = 'Group Added'
      redirect_to @group
    else
      flash[:error] = @group.errors.full_messages
      redirect_to new_group_path(id: @group, organization: params[:group][:organization])
    end
  end

  def playsquads
    @groups = Group.playsquads

    authorize! :read, Group
  end

  def add_user
    @group = Group.find(params[:id])

    count = 0
    params[:player_group][:user_ids].each do |user_id|
      if not user_id.blank?
        user = User.find(user_id)
        if user && user.add_to_group(@group.code)
          count += 1
        end
      end
    end

    respond_to do |format|
      format.json {render json: {message: "Successfully added "+ count.to_s() +" new players.",users: @group.users},status: :ok}
    end
  end

  def remove_user
    @group = Group.find(params[:id])

    count = 0
    params[:player_group][:user_ids].each do |user_id|
      if not user_id.blank?
        user = User.find(user_id)
        if user && user.remove_from_group(@group.code)
          count += 1
        end
      end
    end

    respond_to do |format|
      format.json {render json: {message: "Successfully removed "+ count.to_s() +" new players.",users: @group.users},status: :ok}
    end
  end
end