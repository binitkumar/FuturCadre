require "acts_as_commentable"

class GroupsController < ApplicationController

  before_filter :authenticate_user!, :except => [:index, :group_details, :group_body, :group_members, :group_wall, :group_question, :create_question,
                                                 :search_group, :show_group, :set_salary, :update_salary, :answer_question, :create_answer, :set_rating, :group_event, :create_event]

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
    unless params[:event_id].blank?
      @event            = Event.find_by_id(params[:event_id])
      @event.is_approve = true
      @event.save
      EventMailer.event_notification(current_user.email, @group.users, @event, request.protocol, request.host_with_port).deliver
    end
    #@groups     = Group.all
    #render :json => { :html => render_to_string(:partial => '/groups/first_group_details', :locale=>{ :group => @group }) }.to_json
  end

  def request_join
    @group = Group.find_by_id(params[:group_id])
    @user  = User.find_by_id(current_user.id)
    @user.groups << Group.find_by_id(@group.id)
    render :json => { :html => render_to_string(:partial => '/groups/group_description', :locale => { :group => @group }) }.to_json
  end

  def group_wall
    @group    = Group.find(params[:id])
    @comment  = @group.comments.build
    @comments = @group.comments.all
    render :json => { :html => render_to_string(:partial => '/groups/group_wall', :locale => { :group => @group }) }.to_json
  end


  def group_members
    member_partial = params[:sid]
    @group         = Group.find(params[:id])
    @group_jobs    = @group.jobs
    render :json => { :html => render_to_string(:partial => '/groups/group_members', :locale => { :group => @group, :sid => member_partial }) }.to_json

  end

  def group_jobs
    job_partial = params[:sid]
    @group      = Group.find(params[:id])
    @group_jobs = @group.jobs
    render :json => { :html => render_to_string(:partial => '/groups/group_jobs', :locale => { :group => @group, :sid => job_partial }) }.to_json
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
    @group      = Group.find(params[:group_id])
    @user       = current_user
    @new_comment= @group.comments.create(params[:comment])
    @new_comment.update_attributes(:user_id => @user.id)
    @comments = @group.comments.all
    render :json => { :html => render_to_string(:partial => '/groups/group_wall', :locale => { :group => @group }) }.to_json
  end

  def search_group
    @group_result= Group.find_all_by_name(params[:search_term])
    render :json => { :html => render_to_string(:partial => '/groups/search_result') }.to_json
  end

  def group_question
    @group = Group.find(params[:id])
    render :json => { :html => render_to_string(:partial => '/groups/group_question', :locale => { :group => @group }) }.to_json
  end

  def create_question
    @group = Group.find(params[:group_id])

    @question = Question.new(params[:question])
    @question.update_attributes(:group_id => @group.id)
    if user_signed_in?
      @question.update_attributes(:user_id => current_user.id)
    else
      @question.update_attributes(:user_id => nil)
    end
    if @question.save!
      render :json => { :html => render_to_string(:partial => '/groups/group_question', :locale => { :group => @group }) }.to_json
    end
  end

  def group_body
    @group = Group.find(params[:id])
    render :json => { :html => render_to_string(:partial => '/groups/group_body', :locale => { :group => @group }) }.to_json
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

  def set_rating
    @group = Group.find(params[:group_id])
    @group.rating.update_attributes(:rate => params[:rate])
    render :text => "Ok"
  end

  def set_salary
    @group = Group.find(params[:id])
    render :json => { :html => render_to_string(:partial => '/groups/salary_popup', :locale => { :group => @group }) }.to_json

  end

  def update_salary
    @group_type   = GroupType.find_by_id(params[:group_type])
    @group        = Group.find(params[:group_id])
    @group_salary = ""
    unless params[:group_salary].blank?
      @group_salary = @group.new_salary(params[:group_salary].to_i)
    end
    @group.update_attributes(:mean_salary => @group_salary)
    @groups = Group.find_all_by_group_type_id(@group_type.id)
    render :json => { :html => render_to_string(:partial => '/groups/group_holder', :locale => { :groups => @groups }) }.to_json
  end

  def answer_question
    @question = Question.find_by_id(params[:id])
    @answer   = Answer.new(params[:answer])
    render :json => { :html => render_to_string(:partial => '/groups/answer_question', :locale => { :question => @question }) }.to_json

  end

  def create_answer
    @question = Question.find(params[:quest_id])
    @answer   = Answer.new(params[:answer])
    @answer.update_attributes(:question_id => @question.id)
    if user_signed_in?
      @answer.update_attributes(:user_id => current_user.id)
    else
      @answer.update_attributes(:user_id => nil)
    end
    render :json => { :html => render_to_string(:partial => '/groups/answer_question', :locale => { :question => @question }) }.to_json
  end

  def render_group_details
    @group = Group.find(params[:group_id])
    @user  = current_user
    render :json => { :html => render_to_string(:partial => '/groups/group_wall', :locale => { :group => @group }) }.to_json
  end

  def group_event
    @group = Group.find(params[:id])
    render :json => { :html => render_to_string(:partial => '/groups/group_events', :locale => { :group => @group }) }.to_json
  end

  def create_event
    @group            = Group.find(params[:group_id])
    @event            = Event.new(params[:event])
    @event.group_id   = @group.id
    @event.is_approve = false
    unless current_user.blank?
      @event.user_id = current_user.id
    end
    if @event.save!
      render :json => { :html => render_to_string(:partial => '/groups/group_events', :locale => { :group => @group }) }.to_json
      unless current_user.blank?
        @manager = @group.owner
        EventMailer.event_approval(current_user.email, @manager.email, @event, request.protocol, request.host_with_port, @group).deliver
         approve = group_details_groups_url(:id => @group.id, :event_id => @event.id)
       current_user.send_message("Request for Approval", "I have created this event '#{@event.title}'. Kindly '<a href='#{approve}'> approve</a>  ",@manager)

        #EventMailer.event_notification(current_user, @manager, @event).deliver
      end
    end
  end

  def event_page

  end

end
