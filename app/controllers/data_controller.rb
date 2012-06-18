class DataController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :json

  def index
    @data = AdaData.page params[:page]
    respond_with @data
  end

  def recent
    @data = AdaData.where(gameName: "APA:Tracts").where(:created_at.gt => params[:since]).where(key: "Colon Position")
    respond_to do |format|
      format.json { render :json => @data }
    end
  end

  def show
    @data = AdaData.find(params[:id])
    authorize! :read, @data
    respond_with @data
  end

  def create
    @data = []
    if params[:data]
      params[:data].each do |datum|
        data = AdaData.new(datum)
        data.user = current_user
        data.save
        @data << data
      end
    end

    return_value = {}
    respond_with return_value, :location => ''
  end
end
