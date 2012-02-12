class InvitationMailer < ActionMailer::Base
  def invitation(invitation, group)
    sender = current_user
    @group  = group
    @message = body
    mail(:to =>invitation.invitee_email, :from => sender.email, :subject => "Invitation to Join", :body => {:invitation => invitation, :group =>@group})
  end
end
