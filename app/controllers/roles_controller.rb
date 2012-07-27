class RolesController < ApplicationController
  respond_to :html, :json
  
  def index
    @roles = Role.page params[:page]
    respond_to do |format|
      format.html { @roles = Role.page params[:page] }
      format.json { render :json => Role.all }
    end
  end
end