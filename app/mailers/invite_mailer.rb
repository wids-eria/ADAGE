class InviteMailer < Devise::Mailer

  def class_invitation_instructions(record)
  	@token =  record.invitation_token
    devise_mail(record, :class_invitation_instructions)
  end

  def organization_invitation_instructions(record,group)
    record[:group] = group
  	@token =  record.user.invitation_token
    devise_mail(record, :organization_invitation_instructions)
  end

  def class_invite(record,group)
    record[:group] = group
    devise_mail(record, :class_invite)
  end
end