require "acts_as_commentable"

class GroupsController < ApplicationController

  before_filter :authenticate_user!, :except => [:index, :group_details,:group_body, :group_members, :group_wall, :group_question,:create_question,
  :search_group,:show_group]

  def index
    unless params[:locale].blank?
      @group_type = GroupType.find_by_name(params[:locale])
      @groups     = @group_type.groups
      #@group    = Group.first
      #@comments = @group.comments.all
      respond_to do |format|
        format.html # index.html.erb
        format.json { render :json => @groups }
      end
    end
  end

  def group_details
    @group = Group.find(params[:id])
    if @group.group_type.name == "Job"
      @groups = Group.find_all_by_group_type_id(1)
    elsif @group.group_type.name == "School"
      @groups = Group.find_all_by_group_type_id(2)
    end
    @group_jobs = @group.jobs
    @comments   = @group.comments.all
    #@groups     = Group.all
    #render :json => { :html => render_to_string(:partial => '/groups/first_group_details', :locale=>{ :group => @group }) }.to_json
  end

  def request_join
    @group = Group.find_by_id(params[:group_id])
    @user  = User.find_by_id(current_user.id)
    @user.groups << Group.find_by_id(@group.id)
    render :json => { :html => render_to_string(:partial => '/groups/group_description', :locale=>{ :group => @group }) }.to_json
  end

  def group_wall
    @group    = Group.find(params[:id])
    @comment  = @group.comments.build
    @comments = @group.comments.all
    render :json => { :html => render_to_string(:partial => '/groups/group_wall', :locale=>{ :group => @group }) }.to_json
  end


  def group_members
    member_partial = params[:sid]
    @group         = Group.find(params[:id])
    @group_jobs    = @group.jobs
    render :json => { :html => render_to_string(:partial => '/groups/group_members', :locale=>{ :group => @group, :sid => member_partial }) }.to_json

  end

  def group_jobs
    job_partial = params[:sid]
    @group      = Group.find(params[:id])
    @group_jobs = @group.jobs
    render :json => { :html => render_to_string(:partial => '/groups/group_jobs', :locale=>{ :group => @group, :sid => job_partial }) }.to_json
  end

  def group_page
    @group_page = Group.find(params[:gid])
    @s_job      = Job.find(params[:id])
  end

  def show_group
    @group  = Group.find(params[:id])
    @groups = Group.all
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def add_comment
    @group = Group.find(params[:group_id])
    @group.comments.create(params[:comment])
    @comments = @group.comments.all
    render :json => { :html => render_to_string(:partial => '/groups/group_wall', :locale=>{ :group => @group }) }.to_json
  end

  def search_group
    @group_result= Group.find_all_by_name(params[:search_term])
    render :json => { :html => render_to_string(:partial => '/groups/search_result') }.to_json
  end

  def group_question
    @group = Group.find(params[:id])
    render :json => { :html => render_to_string(:partial => '/groups/group_question', :locale=>{ :group => @group }) }.to_json
  end

  def create_question
    @group = Group.find(params[:group_id])
    @group.questions.create(params[:question])
    render :json => { :html => render_to_string(:partial => '/groups/group_question', :locale=>{ :group => @group }) }.to_json
  end

  def group_body
    @group = Group.find(params[:id])
    render :json => { :html => render_to_string(:partial => '/groups/group_body', :locale=>{ :group => @group }) }.to_json
  end

  def faker_join
    @group = Group.find(params[:id])
    if @group.group_type.name == "Job"
      @groups = Group.find_all_by_group_type_id(1)
    elsif @group.group_type.name == "School"
      @groups = Group.find_all_by_group_type_id(2)
    end
    @group_jobs = @group.jobs
    @comments   = @group.comments.all
    render :action => "group_details"
  end
end
