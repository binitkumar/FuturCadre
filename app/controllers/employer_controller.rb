class EmployerController < ApplicationController
  before_filter :authorize_user
  before_filter :check_employer


  def dashboard
    @employer = current_user


  end


  def employer_jobs
    @employer = User.find_by_id(params[:edi])
    @jobs     = Job.find_all_by_employer_id(@employer.id, :conditions => { :is_deleted => false })
    render :json => { :html => render_to_string(:partial => '/employer/employer_job', :locale => { :employer => @employer }) }.to_json
  end

  def employer_statistics

  end

  def event
    @employer = User.find_by_id(params[:eid])
    render :json => { :html => render_to_string(:partial => '/employer/event_employer', :locale => { :employer => @employer }) }.to_json
  end

  def new_event
    @employer = User.find_by_id(params[:eid])
    @event    = Event.new
    @picture  = Photo.new(params[:picture])
    render :json => { :html => render_to_string(:partial => '/employer/event_form', :locale => { :employer => @employer }) }.to_json
  end


  def create_event

    @employer = User.find_by_id(params[:employer_id])
    unless params[:event_mailer].blank?
      @new_event = Event.create!(params[:event_mailer])
      @new_event.update_attributes(:owner_id => @employer)
      @employer.events << @new_event
    end

    unless params[:picture].blank?
      @picture              = Photo.new(params[:picture])
      @picture.content_type = "event_image"
      @picture.imageable_id = @new_event
      @picture.save
    end


    #if @new_event.save
    render :json => { :html => render_to_string(:partial => '/employer/event_employer', :locale => { :employer => @employer }) }.to_json
    #else
    #   render :json => { :html => render_to_string(:partial => '/employer/event_form', :locale=>{ :employer => @employer }) }.to_json
    #end
  end

  def delete_job
    @employer = User.find(params[:em_id])
    @job      = Job.find(params[:id])
    @job.update_attributes(:is_deleted => true)
    @jobs = Job.find_all_by_employer_id(@employer.id, :conditions => { :is_deleted => false })
    render :json => { :html => render_to_string(:partial => '/employer/employer_job', :locale => { :employer => @employer }) }.to_json
  end


  def my_job_detail
    @job          = Job.find(params[:id])
    @applied_jobs = @job.applied_jobs
    render :json => { :html => render_to_string(:partial => '/employer/my_job_details', :locale => { :employer => @employer }) }.to_json
  end

  def contact_information
    @job_application = AppliedJob.find(params[:id])
    render :json => { :html => render_to_string(:partial => '/employer/contact_form_popup', :locale => { :job_application => @job_application }) }.to_json

  end

  def contact_job_seeker
    @job_application = AppliedJob.find(params[:job_application])
    @user            = @job_application.user
    @job             = @job_application.job
    @employer        = @job_application.job.employer
    @title           = params[:title]
    @body            = params[:body]
    ContactMailer.interview_email(@user, @employer, @job, @title, @body).deliver
    current_user.send_message("Interview Call", "You have been selected for the interview of '#{@job.name}' applied at '#{@job_application.created_at.strftime("%d-%m-%Y")}'", @user)
    render :text => 'ok'
  end

  def download
    @asset = Asset.find(params[:id])
    @cv    = @asset.photo
    send_file @cv.path

  end

  def my_theses
    @employer  = User.find_by_id(params[:id])
    @my_theses = Thesis.find_all_by_owner_id(@employer, :conditions => { :is_deleted => false })
    render :json => { :html => render_to_string(:partial => '/employer/my_theses') }.to_json
  end

  def search_job_seeker
    @contracts        = Contract.all
    @categories       = Category.all
    @employer         = current_user
    @deleted_profiles = EmployerProfile.find_all_by_employer_id(@employer.id)
    @deleted_profiles.each do |del|
      del.update_attributes(:is_deleted => true)
    end
    render :json => { :html => render_to_string(:partial => '/employer/search_job_seeker_form') }.to_json
  end

  def view_cv

    @profile = Profile.find_by_user_id(params[:id])
    render :json => { :html => render_to_string(:partial => '/employer/show_profile', :locals => { :profile => @profile }) }.to_json
  end

  def select_profile
    @collections      = params[:col]
    @profile          = Profile.find_by_user_id(params[:id])
    @employer         = current_user
    @selected_profile = EmployerProfile.new
    @selected_profile.update_attributes(:profile_id => @profile.id, :employer_id => @employer.id, :employer_type => "User")
    @selected_profiles = EmployerProfile.find_all_by_employer_id(@employer.id, :conditions => { :is_deleted => false })
    render :json => { :html => render_to_string(:partial => '/employer/right_panel', :locals => { :collections => @collections, :selected_profiles => @selected_profiles }) }.to_json
  end

end
