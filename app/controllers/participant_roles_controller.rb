class ParticipantRolesController < ApplicationController
  respond_to :html, :json
  
  def update 
    @role = ParticipantRole.find(params[:id])
    @users = User.where(id: params[:player_group][:user_ids])
    @users.each do |user|
       @join = Assignment.where(role_id: @role.id, user_id: user.id).first
       if @join == nil
        @join = Assignment.new :assigner => current_user, :role => @role, :user => user 
        @join.save
        user.roles << @role
       elsif @join.assigner_id == nil
        @join.assigner_id = current_user.id
        @join.save
       end
    end
    if @role.save
      redirect_to game_path(@role.game)
    else
      flash[:error] = @role.errors
      redirect_to :back
    end
  end
end
