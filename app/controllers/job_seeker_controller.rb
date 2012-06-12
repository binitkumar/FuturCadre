class JobSeekerController < ApplicationController

  before_filter :authorize_user
  before_filter :check_job_seeker

  def dashboard
    @job_seeker  = current_user
    @latest_jobs = Job.all
    @my_jobs     = current_user.jobs
  end

  def resume_index
    unless current_user.profile.blank?
      @resumes = current_user.profile.assets.where(:content_type => 'cv', :is_deleted => false)
    end
    render :partial => 'resume_list'
  end

  def add_cv
    @cv = Asset.new
    render :partial => "job_seeker/new_resume_form", :locals => { :cv => @cv }
  end

  def event
    @job_seeker = User.find_by_id(params[:jid])
    render :json => { :html => render_to_string(:partial => '/job_seeker/event_job_seeker', :locale => { :job_seeker => @job_seeker }) }.to_json
  end

  def new_event
    @job_seeker = User.find_by_id(params[:jid])
    @event      = Event.new
    @picture    = Photo.new(params[:picture])
    render :json => { :html => render_to_string(:partial => '/job_seeker/event_form', :locale => { :job_seeker => @job_seeker }) }.to_json
  end


  def create_event
    @job_seeker = User.find_by_id(params[:job_seeker_id])
    unless params[:event_mailer].blank?
      @new_event = Event.create!(params[:event_mailer])
      @new_event.update_attributes(:owner_id => @job_seeker)
      @job_seeker.events << @new_event
    end
    unless params[:picture].blank?
      @picture              = Photo.new(params[:picture])
      @picture.content_type = "event_image"
      @picture.imageable_id = @new_event
      @picture.save
    end
    #if @new_event.save
    render :json => { :html => render_to_string(:partial => '/job_seeker/event_job_seeker', :locale => { :job_seeker => @job_seeker }) }.to_json
    #else
    #   render :json => { :html => render_to_string(:partial => '/employer/event_form', :locale=>{ :employer => @employer }) }.to_json
    #end
  end

  def job_seeker_jobs
    @job_seeker   = User.find(params[:id])
    @applied_jobs = @job_seeker.applied_jobs
    render :json => { :html => render_to_string(:partial => '/job_seeker/job_list', :locale => { :job_seeker => @job_seeker }) }.to_json
  end

  def new_resume

    @cv              = Asset.new(params[:cv])
    @cv.content_type = "cv"
    @cv.user_id      = current_user.id
    @cv.profile_id   = current_user.profile.id
    if @cv.save
      @resumes = current_user.profile.assets.where(:content_type => 'cv', :is_deleted => false)
      render :partial => 'resume_list'
    else
      render :partial => '/shared/error_messages', :locals => { :object => @cv }
    end


  end

  def my_theses
    @my_theses = Thesis.find_all_by_owner_id(current_user.id, :conditions => { :is_deleted => false })
    render :json => { :html => render_to_string(:partial => '/job_seeker/my_theses') }.to_json
  end

  def delete_cv
    @cv = Asset.find_by_id(params[:id])
    @cv.update_attributes(:is_deleted => true)
    @resumes = current_user.profile.assets.where(:content_type => 'cv', :is_deleted => false)
    render :json => { :html => render_to_string(:partial => 'resume_list') }.to_json
  end

  def make_cv_publishable
    @cv  = Asset.find_by_id(params[:id])
    @cvs = current_user.profile.assets.where(:content_type => 'cv', :is_publishable => true)
    unless @cvs.blank?
      @cvs.each do |cv|
        cv.update_attributes(:is_publishable => false)

      end
    end
    @cv.update_attributes(:is_publishable => true)
    @resumes = current_user.profile.assets.where(:content_type => 'cv', :is_deleted => false)
    render :json => { :html => render_to_string(:partial => 'resume_list') }.to_json
  end


end
