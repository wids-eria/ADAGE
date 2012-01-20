class DataController < ApplicationController
  respond_to :html, :json

  def index
    @data = AdaData.all
    respond_with @data
  end

  def show
    @data = AdaData.find(params[:id])
    respond_with @data
  end

  def create
    if params[:data]
      params[:data].each do |datum|
        AdaData.create datum
      end
    end

    return_value = {}
    respond_with return_value, :location => ''
  end
end
