class GroupsController < ApplicationController

  #before_filter :authenticate_user!
  def index
    @groups = Group.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @groups }
    end
  end

  def group_details
    @group      = Group.find(params[:id])
    @group_jobs = @group.jobs
    render :json => { :html => render_to_string(:partial => '/groups/group_details') }.to_json
     #render :partial => '/groups/group_details', :layout => false
  end

  def request_join
    @group = Group.find_by_id(params[:id])
    #render :json => { :html => render_to_string(:partial => '/groups/group_join_form') }.to_json
    render :partial => "groups/group_join_form"   ,:layout => false

  end

end
