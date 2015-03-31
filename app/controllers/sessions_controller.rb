class SessionsController < Devise::SessionsController

  def create
    super
    current_user.add_to_group(params[:user][:group])

    session[:portal] = false
  end

  def new
    @code = session[:portal]
  end


  def delete
    super

    if params[:redirect_uri]
      redirect_to params[:redirect_uri]
    end
  end
end
