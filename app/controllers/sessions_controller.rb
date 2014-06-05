class SessionsController < Devise::SessionsController

  def create
    super
    current_user.add_to_group(params[:user][:group])
  end

  def new
    @code = params[:code]
  end
end
