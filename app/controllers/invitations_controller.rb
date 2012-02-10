class InvitationsController < ApplicationController


  def project_invitation
    @project            = Project.find_by_id(params[:id])
    @project_invitation = ProjectUser.new
    @sender_id          = current_user
    render :json => { :html => render_to_string(:partial => 'project_invitation', :locale=>{ :project => @project }) }.to_json
  end

  def send_invitation
    puts "aaaaaaaaaaaa", params[:project_invitation].inspect, params[:project_id].inspect
    @current_project = Project.find_by_id(params[:project_id])
    @send_invitation = ProjectUser.new(params[:project_invitation])
    @send_invitation.update_attributes(:project_id => @current_project.id, :sender_id => current_user.id, :invite =>true)
    @search_user = User.find_by_email(@send_invitation.invitee_email)
    puts "adddddddddddddd", @search_user.inspect
    unless @search_user.blank?
      puts "asssssssssssdddd"
      @send_invitation.update_attributes(:user_id => @serch_user.id, :is_user => true)
    else
      puts "elseeeeeeeeeeeeeee"
      @send_invitation.update_attributes(:is_user => false)
    end

    render :text =>"ok"
  end

end
