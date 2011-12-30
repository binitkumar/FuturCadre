class Admin::GroupsController < ApplicationController
  before_filter :check_role
  before_filter :authenticate_user!
  layout "admin"

  def index
    @groups = Group.all
  end

  def job_groups
    @group      = Group.find_by_id(params[:id])
    @group_jobs = @group.jobs
  end

  def new
    @group = Group.new
    #@jobs  = Job.all
  end

  def create
    @group_new       = Group.new(params[:group])
    @group_new.owner = User.first
    jobs             = []
    jobs             = params[:job_id]

    jobs.each do |job|
      @group_job = Job.find_by_id(job)
      @group_new.jobs << Job.find_by_id(@group_job.id)
    end

    if @group_new.save
      redirect_to admin_groups_path, :notice => 'Group was successfully created.'
    else
      render :action => "new"
    end
  end


  def edit
    @group      = Group.find(params[:id])
    @group_jobs = @group.jobs
    @jobs       =[]
    Job.all.each do |job|
      if  @group_jobs.find_by_id(job)
      else
        @jobs << job
      end
    end
  end

  def update
    @group = Group.find(params[:id])

    jobs = []
    jobs = params[:job_id]
    jobs.each do |job|
      @group_job = Job.find_by_id(job)
      @group.jobs << Job.find_by_id(@group_job.id)
    end
    if @group.update_attributes(params[:group])
      redirect_to admin_groups_path, :notice => 'Group was successfully updated.'
    else
      render :action => "edit"
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to admin_groups_url
  end

  def remove_job
    @remove_job = Job.find_by_id(params[:job_id])
    @group      = Group.find_by_id(params[:group_id])
    @group.jobs.destroy(@remove_job.id)
    @group_jobs = @group.jobs

    @jobs =[]
    Job.all.each do |job|
      if  @group_jobs.find_by_id(job)
      else
        @jobs << job
      end
    end
   render :partial => "group_job_list", :locals => { :jobs => @jobs, :group => @group }
    #render :json => { :html => render_to_string(:partial => '/admin/groups/group_job_list', :locale=>{ :jobs => @jobs, :group => @group }) }.to_json
  end
end
