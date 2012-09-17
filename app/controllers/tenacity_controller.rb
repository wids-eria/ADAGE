class TenacityController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html

  def index
    @users = Array.new
    User.all.each do |player|
      if not player.data.where(gameName: 'Tenacity-Meditation').empty?
        @users << player
      end
    end
    authorize! :read, @users
  end
end
