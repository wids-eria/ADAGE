class WelcomeController < ApplicationController
  before_filter :authenticate_user!, :only => :my_page

  def index
    if user_signed_in?
      redirect_to games_url
    else
      redirect_to new_user_session_url
    end
  end

  def profile

    @games = Array.new
    Game.all.each do |game|
      if can? :read, game
        @games << game
      end
    end

    render :index
  end
end
