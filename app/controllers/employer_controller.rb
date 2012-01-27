class EmployerController < ApplicationController
  before_filter :authenticate_user!

  def dashboard
    @employer = current_user

  end


  def employer_jobs
    @employer = User.find_by_id(params[:edi])
    @jobs     = Job.find_all_by_employer_id(@employer.id, :conditions => { :is_deleted => false })
    render :json => { :html => render_to_string(:partial => '/employer/employer_job', :locale=>{ :employer => @employer }) }.to_json
  end

  def employer_statistics

  end

  def event
    @employer = User.find_by_id(params[:eid])

    render :json => { :html => render_to_string(:partial => '/employer/event_employer', :locale=>{ :employer => @employer }) }.to_json

  end

  def new_event
    @employer = User.find_by_id(params[:eid])
    @event    = Event.new
    @picture  = Photo.new(params[:picture])
    render :json => { :html => render_to_string(:partial => '/employer/event_form', :locale=>{ :employer => @employer }) }.to_json
  end


  def create_event

    @employer = User.find_by_id(params[:employer_id])
    unless params[:event].blank?
      @new_event = Event.create!(params[:event])
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
    render :json => { :html => render_to_string(:partial => '/employer/event_employer', :locale=>{ :employer => @employer }) }.to_json
    #else
    #   render :json => { :html => render_to_string(:partial => '/employer/event_form', :locale=>{ :employer => @employer }) }.to_json
    #end
  end

  def delete_job
    @employer = User.find(params[:em_id])
    @job      = Job.find(params[:id])
    @job.update_attributes(:is_deleted => true)
    @jobs = Job.find_all_by_employer_id(@employer.id, :conditions => { :is_deleted => false })
    render :json => { :html => render_to_string(:partial => '/employer/employer_job', :locale=>{ :employer => @employer }) }.to_json
  end

end
