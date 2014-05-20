class RegistrationsController < Devise::RegistrationsController
  #Class to extend the devise controller to add custom teacher_status to the devise reigstration

  def create
    #Get teacher_status and convert it to the correct enum before devise saves the user
    status = params[:user][:teacher_status_cd]

    if status == "0"
      params[:user].delete("teacher_status_cd")
    else
      params[:user][:teacher_status] = "pending"
    end
    super
  end
end