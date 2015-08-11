class DashboardsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_subdomain
  
  respond_to :html, :json
  layout 'homepage'

  def homepage
    @classes = current_user.owned_groups.where(organization_id: @org)
    @games = Game.joins(:groups).where('groups.id' => @classes).all
  end


  def show
    @game = Game.find(params[:id])

  end

  protected
    def get_subdomain
      subdomain = request.subdomain(0)
      @org = Organization.where(subdomain: subdomain).first
      
      authorize! :manage, @org
    end
end
