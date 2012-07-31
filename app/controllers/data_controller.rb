class DataController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :json

  def index
    @data = AdaData.page params[:page]
    authorize! :read, @data
    respond_with @data
  end

  def get_data_by_game
    @data = AdaData.where(gameName: params[:game_name])
    authorize! :read, @data
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
