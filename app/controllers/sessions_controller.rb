class SessionsController < Devise::SessionsController

  def create
    super
    current_user.add_to_group(params[:user][:group])

    session[:portal] = false
  end

  def new
    @code = session[:portal]
  end
end
