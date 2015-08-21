class OrganizationsController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource :only => :playsquads
  before_filter :authenticate_user!
  layout 'blank'

  def index
    @orgs = Organization.all
  end

  def show
    @org = Organization.find(params[:id])
  end

  def edit
    @org = Organization.find(params[:id])
  end

  def update
    @org = Organization.find(params[:id])
    if @org.update_attributes params[:organization]
      flash[:notice] = 'organization Updated'
      redirect_to @org
    else
      render :edit
    end
  end

  def new
    @org = Organization.new(params[:organization])
  end

  def create
    @org = Organization.new(params[:organization])
    if @org.save
      OrganizationRole.create(organization: @org, user: current_user, name: "admin").errors.full_messages


      flash[:notice] = 'organization Added'
      redirect_to @org
    else
      render :new
    end
  end
end