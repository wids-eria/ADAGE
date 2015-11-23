class DashboardsController < ApplicationController
  before_filter :get_subdomain
  before_filter :authenticate_user!
  protect_from_forgery :except => :show

  respond_to :html, :json
  layout 'homepage'

  def homepage
    @orgs = current_user.organizations
    @owned_classes = current_user.owned_groups.classes.where(organization_id: @org)
    # current_user.groups.classes.each do |potentialClass|
    #   if potentialClass.organization_id == @org.id
    #     @classes << potentialClass
    #   end
    # end
    @joined_classes = current_user.groups.classes.where(organization_id: @org)
    @games_from_owned = Game.select("DISTINCT games.*").joins(:groups).where('groups.id' => @joined_classes)
    @games_from_joined = Game.select("DISTINCT games.*").joins(:groups).where('groups.id' => @owned_classes)
    @classes = (@owned_classes.to_a << @joined_classes.to_a).flatten
    @games = (@games_from_owned.to_a << @games_from_joined.to_a).flatten
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

    @joined_classes = current_user.groups.classes.where(organization_id: @org)
    @owned_classes = current_user.owned_groups.classes.where(organization_id: @org)
    @classes = (@owned_classes.to_a << @joined_classes.to_a).flatten
    @users = @class.users.pluck(:id)

    # @users = [1,61376, 61878, 61993, 245, 61899]
    # @users = [61354 , 61353]

    # THIS NEEDS TO BE UNCOMMENTED
    # authorize! :read, @game
    # authorize! :manage, @class
    params[:page_title] = @game.name
    breadcrumb("#{@game.name} Dashboard")
  end

  protected
    def get_subdomain
      subdomain = request.subdomain(0).split(".")[0]
      @org = Organization.where(subdomain: subdomain).first
    end
end
