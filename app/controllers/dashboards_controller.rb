class DashboardsController < ApplicationController
  before_filter :get_subdomain
  before_filter :authenticate_user!
  
  respond_to :html, :json
  layout 'homepage'

  def homepage
    if current_user.teacher?(@org) or current_user.admin?
      @orgs = current_user.organizations
      @classes = current_user.owned_groups.classes.where(organization_id: @org)
      @games = Game.select("DISTINCT games.*").joins(:groups).where('groups.id' => @classes)
    end

    if current_user.student?(@org)
      @orgs = current_user.organizations
      @classes = current_user.groups.classes.where(organization_id: @org)
      @games = Game.select("DISTINCT games.*").joins(:groups).where('groups.id' => @classes)
    end

    params[:page_title] = "Homepage"
    breadcrumb("Homepage",true)
  end

  def show
    @game = Game.find(params[:id])
    @class = Group.find(params[:class_id])

    if params[:student_id]
      @student = User.find(params[:student_id])
    end
    @classes = current_user.owned_groups.classes.where(organization_id: @org).joins(:games).where('games.id' => @game)


    authorize! :read, @game
    authorize! :manage, @class

    params[:page_title] = @game.name
    breadcrumb("#{@game.name} Dashboard")
  end

  protected
    def get_subdomain
      subdomain = request.subdomain(0)
      @org = Organization.where(subdomain: subdomain).first
    end
end
