class JobsController < ApplicationController

  def show
    @job = Job.find_by_id(params[:id])
  end

  def details
    @job = Job.find_by_id(params[:id])

    if params[:sid]=="job"
    render :json => { :html => render_to_string(:partial => '/jobs/details') }.to_json
    else
    render :json => { :html => render_to_string(:partial => '/groups/group_job') }.to_json
    end
  end


  def new
    @job            = Job.new
    @skill          = Skill.new(params[:skills])
    @responsibility = Responsibility.new(params[:respon])

  end

  def create_job

    @job_new = Job.new(params[:job])
    @job_new.update_attributes(:employer_id => current_user.id, :category_id => params[:category_id])

    unless params[:respon].blank?
      @responsibility = Responsibility.create(params[:respon])
    else
      puts "None responsibility added"
    end
    unless params[:skill].blank?
      @skill_new = Skill.create(params[:skill])
    else
      puts "None skill added"
    end
    #  #  currently we have one skill and Repsonsibility so we ll not user loop for inserting into
    ##intermediate table
    @job_new.skills << Skill.find_by_id(@skill_new.id)
    @job_new.responsibilities << Responsibility.find_by_id(@responsibility.id)
    if @job_new.save
      redirect_to(@job_new, :notice => 'Profile was successfully created.')
    else
      redirect_to :action => "new"
    end
  end


  def apply_job

  end

end


