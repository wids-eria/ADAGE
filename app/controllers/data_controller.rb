class DataController < ApplicationController
  def create
    if params[:data]
      params[:data].each do |datum|
        AdaData.create datum
      end
    end

    render :text => "woo"
  end
end
