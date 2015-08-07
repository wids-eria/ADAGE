class ClassesController < ApplicationController
  before_filter :authenticate_user!
  layout 'homepage'

  def index
    @group = Group.find(params[:id])
    authorize! :read, @group

  end

  def show
    @group = Group.find(params[:id])
    authorize! :read, @group
  end


  def edit
    @group = Group.find(params[:id])
    authorize! :manage, @group

  end


  def update
    @group = Group.find(params[:id])

    subdomain = request.subdomain(0)
    @org = Organization.where(subdomain: subdomain).first
    authorize! :manage, @org

    params[:group][:group_type] = "class"
    params[:group][:organization] = @org

    if @group.update_attributes params[:group]
      flash[:notice] = 'Class Updated'
      redirect_to class_path(@group)
    else
      render :edit
    end
  end

  def new
    subdomain = request.subdomain(0)
    @org = Organization.where(subdomain: subdomain).first
    authorize! :manage, @org

    @group = Group.new(params[:group])
  end

  def create
    subdomain = request.subdomain(0)
    @org = Organization.where(subdomain: subdomain).first
    authorize! :manage, @org

    @group = Group.new(params[:group])
    @group.group_type = "class"
    @group.organization = @org
    if @group.save
      @owner = GroupOwnership.create(user: current_user,group:@group)

      flash[:notice] = 'Class Added'
      redirect_to class_path(@group)
    else
      flash[:error] = @group.errors.full_messages
      redirect_to new_class_path(id: @group)
    end
  end
end