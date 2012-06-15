class EmployerController < ApplicationController
  require 'rubygems'
  require 'active_merchant'
  include ActiveMerchant::Billing

  before_filter :authenticate_user!
  before_filter :authorize_user
  before_filter :check_employer


  def dashboard
    @employer           = current_user
    @available_jobs     = current_user.avail_jobs - current_user.created_jobs.count
    @applied_jobs       = AppliedJob.find_all_by_employer_id(current_user.id)
    @available_searches = current_user.avail_search - @applied_jobs.count

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
    @applied_jobs = @job.applied_jobs.where('is_declined = false')
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
    @applied_jobs = AppliedJob.find_all_by_employer_id(current_user.id, :conditions => { :is_downloaded => true })
    if @applied_jobs.count <= current_user.package.no_of_searches
      @applied_job = AppliedJob.find(params[:id])
      @applied_job.update_attributes(:is_downloaded => true)
      @asset = Asset.find_by_id(params[:cv_id])
      @cv    = @asset.photo
      send_file @cv.path
    else
      redirect_to :controller => "employer", :action => "employer_packages", :notice => "Please buy a package"
    end
  end

  def my_theses
    @employer  = User.find_by_id(params[:id])
    @my_theses = Thesis.find_all_by_owner_id(@employer, :conditions => { :is_deleted => false })
    render :json => { :html => render_to_string(:partial => '/employer/my_theses') }.to_json
  end

  def search_job_seeker
    @contracts        = Contract.all
    @categories       = Category.all
    #@employer         = current_user
    @deleted_profiles = EmployerProfile.find_all_by_employer_id(current_user.id)
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
    @collections = params[:col]
    @profile     = Profile.find_by_user_id(params[:id])
    #@employer         = current_user
    emp          = EmployerProfile.find_all_by_profile_id_and_employer_id(@profile.id, current_user.id, :conditions => { :is_deleted => false })
    if emp.blank?
      @selected_profile               = EmployerProfile.new
      @selected_profile.profile_id    = @profile.id
      @selected_profile.employer_id   = current_user.id
      @selected_profile.employer_type = "User"
      @selected_profile.save!
    end
    @selected_profiles = EmployerProfile.find_all_by_employer_id(current_user.id, :conditions => { :is_deleted => false })
    render :json => { :html => render_to_string(:partial => '/employer/right_panel', :locals => { :collections => @collections, :selected_profiles => @selected_profiles }) }.to_json
  end

  def employer_packages
    @packages           =Package.all
    session[:return_to] ||= request.referer

  end

  def employer_billing_information
    @package=Package.find_by_id(params[:id])

  end

  def checkout
    @package=Package.find_by_id(params[:id])

    amount       = @package.price
    credit_card  = ActiveMerchant::Billing::CreditCard.new(
        :number             => params[:cc_number],
        :month              => params[:cc_expire_month],
        :year               => params[:cc_expire_year],
        :first_name         => params[:first_name],
        :last_name          => params[:last_name],
        :verification_value => params[:v_code]
    )
    billing_info = {
        :first_name => params[:first_name],
        :last_name  => params[:last_name],
        :address1   => params[:address],
        :city       => params[:city],
        :state      => params[:state],
        :country    => params[:country],
        :zip        => params[:zip]
    }

    # Validating the card automatically detects the card type
    if credit_card.valid?
      # Authorize for the amount
      response = STANDARD_GATEWAY.purchase(amount, credit_card, {
          :ip              => request.remote_ip,
          :billing_address => billing_info
      })
      if response.success?
        @user=current_user
        #to insert into package_user table
        @package_user.create(:user_id => current_user.id, :package_id => @package.id)

        #update user available jobs and searches
        @avail_jobs    = @user.avail_jobs + @package.no_of_jobs
        @avail_searches= @user.avail_search + @package.no_of_searches
        @user.update_attributes(:package_id => @package.id, :avail_jobs => @avail_job, :avail_search => @avail_searches)

        flash[:notice] = 'transaction has been successful'
        #redirect_to '/employer/transaction_success_show'
        redirect_to session[:return_to]

      else
        flash[:notice] = response.message
        render :action => :employer_billing_information
      end
    else
      flash[:notice] = 'Invalid credit card details specified'
      render :action => :employer_billing_information
    end
  end

  def transaction_success_show

    # render :template => '/employer/transaction_success_show'
  end

  def decline_applicant
    @job_applied = AppliedJob.find_by_id(params[:id])
    @user        = @job_applied.user
    @job         = @job_applied.job
    @job_applied.update_attributes(:is_declined => true)
    current_user.send_message("Rejection Letter", "Dear #{@user.profile.first_name} You have applied for the '#{@job.name}' at '#{@job_applied.created_at.strftime('%a, %m/%d/%Y')}'. However due to large number of applicants the competition was higher and unfortunately you didn't meet our criteria. We wish you a very successful career ahead' ", @user)
    render :text => "ok"
  end

  def add_search_result
    @profile      = Profile.find_by_id(params[:id])
    @applied_jobs = AppliedJob.find_all_by_employer_id(current_user.id, :conditions => { :is_downloaded => true })
    if @applied_jobs.count <= current_user.package.no_of_searches
      @applied_job                  = AppliedJob.new
      @applied_job.user_id          = @profile.user_id
      @applied_job.employer_id      = current_user.id
      @applied_job.is_system_applied= true
      @profile.assets.each do |asset|
        if asset.content_type =="cv" and asset.is_publishable == true
          @applied_job.cv_id = asset.id
        end
      end
      @applied_job.is_downloaded = true
      @applied_job.save

      render :text => 'ok'
    else
      render :text => 'fail'
    end
  end

  def get_my_orders
    @my_orders = current_user.package_users


  end
end

