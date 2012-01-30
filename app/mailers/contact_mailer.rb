class ContactMailer < ActionMailer::Base

  def interview_email(applicant, sender, job, title, body)
    @user = applicant
    @job  = job
    @message = body
    mail(:to => applicant.email, :from => sender.email, :subject => "Call for an interview")
  end

end
