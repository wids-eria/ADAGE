class SchemasController < ApplicationController
  before_filter :authenticate_user!

  def create
    schema = Schema.new(params[:schema])
    schema.game = Game.where(id: params[:schema][:game_id]).first
    if schema.save
      schema.game.schemas << schema
      flash[:notice] = 'Schema Added'
    else
      flash[:error] = 'Error adding schema'
    end
    redirect_to game_path(schema.game) 
  end

end
