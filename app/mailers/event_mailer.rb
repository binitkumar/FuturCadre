class EventMailer < ActionMailer::Base

  def event_approval(sender, manager, event, protocol, host, group)
    @event = event
    @protocol = protocol
    @host = host
    @group = group
    @sender = sender
    @manager = manager
    puts 'DDDDDDDDDDD', @event.inspect
    mail(:to => "uzair.abid@ilsainteractive.com", :from => @sender, :subject => "Event Notification")
  end

  def event_notification(sender, users, event, protocol, host)
    @sender = sender
    @users = users
    @event = event
    @protocol = protocol
    @host = host
    @us = []
    @users.each do |user|
      @us << user.email
    end
    puts 'DDDDDDDDDDDVVV', @us.inspect
    mail(:to => @us, :from => @sender, :subject => "Event Notification")
  end

end
