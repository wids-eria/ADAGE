class DashboardsController < ApplicationController
  before_filter :get_subdomain
  before_filter :authenticate_user!
  protect_from_forgery :except => :show
  
  respond_to :html, :json
  layout 'homepage'

  def homepage
    @orgs = current_user.organizations
    @classes = current_user.owned_groups.classes.where(organization_id: @org)
    @classes << current_user.groups.classes.where(organization_id: @org)
    @games = Game.select("DISTINCT games.*").joins(:groups).where('groups.id' => @classes)

    params[:page_title] = "Home"
    breadcrumb("Home",true)
  end

  def show
    parse_filters(params[:filters])
    @game = Game.find(params[:id])

    if @filters.has_key?("class_id")
      #User -1 for all users
      if @filters["class_id"] != "-1"
        @class = Group.find(@filters["class_id"])
      end

      #remove key so the data isn't filtered directly
      @filters.delete("class_id")
    elsif params[:dashboard]
      @class = Group.find(params[:dashboard][:class_id])
    end

    if @filters.has_key?("user_id")
      #User -1 for all users
      if @filters["user_id"] != "-1"
        @student = User.find(@filters["user_id"])
      else
        @filters.delete("user_id")
      end
    end
    @classes = current_user.owned_groups.classes.where(organization_id: @org).joins(:games).where('games.id' => @game)
    @users = @class.users.pluck(:id)

    @users = [1,61376, 61878, 61993, 245, 61899]
    authorize! :read, @game
    authorize! :manage, @class
    params[:page_title] = @game.name
    breadcrumb("#{@game.name} Dashboard")
  end

  protected
    def get_subdomain
      subdomain = request.subdomain(0).split(".")[0]
      @org = Organization.where(subdomain: subdomain).first
    end
end
