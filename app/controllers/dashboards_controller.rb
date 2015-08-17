class DashboardsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_subdomain
  
  respond_to :html, :json
  layout 'homepage'

  def homepage
    @orgs = current_user.organizations
    @classes = current_user.owned_groups.classes.where(organization_id: @org)
    @games = Game.select("DISTINCT games.*").joins(:groups).where('groups.id' => @classes)

    params[:page_title] = "Homepage"
    breadcrumb("Homepage",true)
  end


  def show
    @game = Game.find(params[:id])
    @class = Group.find(params[:class_id])
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
      
      authorize! :manage, @org
    end
end
