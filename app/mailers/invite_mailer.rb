class InviteMailer < Devise::Mailer

  def class_invitation_instructions(record)
  	@token =  record.invitation_token
    devise_mail(record, :class_invitation_instructions)
  end

  def organization_invitation_instructions(record)
  	@token =  record.invitation_token
    devise_mail(record, :organization_invitation_instructions)
  end

  def class_invite(record)
    devise_mail(record, :class_invite)
  end
end