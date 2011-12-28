class GroupsController < ApplicationController

  #before_filter :authenticate_user!
  def index
    @groups = Group.all
    @group  = Group.first
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @groups }
    end
  end

  def group_details
    @group      = Group.find(params[:id])
    @group_jobs = @group.jobs
    render :json => { :html => render_to_string(:partial => '/groups/first_group_details', :locale=>{ :group => @group }) }.to_json
  end

  def request_join
    @group = Group.find_by_id(params[:group_id])
    @user  = User.find_by_id(current_user.id)
    @user.groups << Group.find_by_id(@group.id)
    render :json => { :html => render_to_string(:partial => '/groups/first_group_details', :locale=>{ :group => @group }) }.to_json
  end


  def group_page
    @group_page = Group.find(params[:gid])
    @s_job      = Job.find(params[:id])
  end

  def group_job

  end


end
