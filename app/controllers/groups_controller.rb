class GroupsController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource :only => :playsquads
  before_filter :authenticate_user!
  layout 'blank'

  def index
    @groups = Group.all
  end

  def show
    @group = Group.find(params[:id])
    text = @group.code
    @qr = qrcode(text)
  end

  def edit
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
    @group = Group.new(params[:group])
  end

  def create
    @group = Group.new(params[:group])
    if @group.save
      flash[:notice] = 'Group Added'
      redirect_to @group
    else
      render :new
    end
  end

  def playsquads
    @groups = Group.playsquads

    authorize! :read, Group
  end
end