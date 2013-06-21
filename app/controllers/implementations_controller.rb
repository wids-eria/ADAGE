class ImplementationsController < ApplicationController
  before_filter :authenticate_user!

  def create
    imp = Implementation.new(params[:implementation])
    imp.game = Game.where(id: params[:implementation][:game_id]).first
    if imp.save
      imp.game.implementations << imp
      flash[:notice] = 'Implementation Added'
    else
      flash[:error] = 'Error adding implementation'
    end
    redirect_to :back
  end

end
