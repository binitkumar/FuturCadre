class JobSeekerController < ApplicationController

	before_filter :authenticate_user!
	
	def dashboard
    @job_seeker = current_user
		@latest_jobs = Job.all
		@my_jobs = current_user.jobs
  end



end
