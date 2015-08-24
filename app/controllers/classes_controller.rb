class ClassesController < ApplicationController
  require 'CSV'

  before_filter :authenticate_user!, except: [:accept_invite,:process_invite]
  before_filter :get_subdomain, except: [:accept_invite,:process_invite,:join]
  layout 'homepage'

  def index
    @group = Group.find(params[:id])
    authorize! :read, @group
    breadcrumb("Class Management")
  end

  def show
    @group = Group.find(params[:id])
    authorize! :read, @group

    @student = User.new
    

    breadcrumb("#{@group.name} Dashboard")
  end

  def edit
    @group = Group.find(params[:id])
    @games = @org.games
    
    authorize! :read, @org
    authorize! :manage, @group
  end

  def update
    @group = Group.find(params[:id])
    authorize! :read, @org
    authorize! :manage, @group

    params[:group][:group_type] = "class"
    params[:group][:organization] = @org

    if @group.update_attributes params[:group]
      @games = Game.where(id: params[:group][:game_ids],organization_id: @org)
      @group.update_attribute(:games ,@games)

      flash[:notice] = 'Class Updated'
      redirect_to class_path(@group)
    else
      flash[:error] = @group.errors.full_messages
      @games = @org.games
      render :edit
    end
  end

  def new
    authorize! :read, @org
    @group = Group.new(params[:group])
    @games = @org.games

    breadcrumb("Create Class")
  end

  def create
    @group = Group.new(params[:group])
    @group.group_type = "class"
    @group.organization = @org

    if @group.save
      @owner = GroupOwnership.create(user: current_user,group:@group)
      @games = Game.where(id: params[:group][:game_ids],organization_id: @org)
      @group.update_attribute(:games ,@games)

      flash[:notice] = 'Class Added'
      redirect_to class_path(@group)
    else
      flash[:error] = @group.errors.full_messages
      redirect_to new_class_path(id: @group)
    end
  end

  def import
    @group = Group.find(params[:id])
    authorize! :manage, @group

    file =  params[:import][:file].tempfile
    flash[:error] = []
    CSV.foreach(file.path, headers: true) do |row|
      flash[:error] << row[0].to_s
      puts row
    end 

    redirect_to class_path(@group)
  end

  def invite
    @group = Group.find(params[:id])
    authorize! :manage, @group

    @user = User.invite_class!(email: params[:invite][:email])
    unless @user.invitation_accepted_at.nil?
      InviteMailer.class_invite(@user).deliver
    end

    invites = GroupInvite.where(user_id:@user,group_id:@group).exists?
    if(!invites) 
      GroupInvite.create(user:@user,group:@group)
    end

    flash[:notice] = 'Student #{user.email} Invited'
    redirect_to class_path(@group)
  end

  def join
    invites =  GroupInvite.where(user_id:current_user,group_id: params[:id]).all
    invites.each do |invite|
      invite.group.users << current_user
      OrganizationRole.create(organization: invite.group.organization, user: current_user, name: "student")
    end

    invites.each do |invite|
      invite.destroy
    end

    redirect_to homepage_path
  end

  def remove_user
    @group = Group.find(params[:id])
    authorize! :manage, @group
    @group.RemoveUser(params[:user_id])

    flash[:notice] = 'Student #{user.email} Remove From Class'
    redirect_to class_path(@group)
  end

  def accept_invite
    @user = User.find_by_invitation_token(params[:invitation_token])
    @resource = User.find_by_invitation_token(params[:invitation_token])
    @invite = GroupInvite.where(user_id:@user).last

    render "devise/invitations/edit",layout: 'application'
  end

  def process_invite
    @user = User.find(params[:id])
    @invite = GroupInvite.where(user_id:@user).last

    if User.accept_invitation!(params[:user])
      flash[:notice] = 'Account Created!'

      invites =  GroupInvite.where(user_id:@user).all
      invites.each do |invite|
        invite.group.users << @user
        OrganizationRole.create(organization: invite.group.organization, user: current_user, name: "student")
      end

      invites.each do |invite|
        invite.destroy
      end

      sign_in @user, :bypass => true
      redirect_to homepage_path
    else
      render "devise/invitations/edit",layout: 'application'
    end
  end

  protected
    def get_subdomain
      subdomain = request.subdomain(0)
      @org = Organization.where(subdomain: subdomain).first
      authorize! :read, @org
      params[:page_title] = "Class Management"
    end
end