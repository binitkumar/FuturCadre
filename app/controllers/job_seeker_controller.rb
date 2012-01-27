class JobSeekerController < ApplicationController

	before_filter :authenticate_user!
	
	def dashboard
    @job_seeker = current_user
		@latest_jobs = Job.all
		@my_jobs = current_user.jobs
  end

 def resume_index

   @resumes = current_user.profile.assets.where(:content_type => 'cv')
   render :json => { :html => render_to_string(:partial => 'resume_list') }.to_json

 end

end
