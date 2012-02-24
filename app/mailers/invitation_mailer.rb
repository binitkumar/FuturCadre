class InvitationMailer < ActionMailer::Base
  def invitation(invitation, project)
    @project  = project
    @invitation = invitation
    mail(:to =>invitation.invitee_email, :from =>invitation.sender.email, :subject => "Invitation to Join")
  end
end
