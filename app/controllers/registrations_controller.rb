class RegistrationsController < Devise::RegistrationsController
  #Class to extend the devise controller to add custom teacher_status to the devise reigstration

  def create
    #Get teacher_status and convert it to the correct enum
    status = params[:user][:teacher_status]
    if status == "0"
      params[:user].delete("teacher_status")
    else
      params[:teacher_status] = "pending"
    end
    super
  end
end