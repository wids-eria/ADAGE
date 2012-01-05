class DataController < ApplicationController
  respond_to :html, :json

  def index
    @data = AdaData.all
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
