class JobSeekerController < ApplicationController

	before_filter :authenticate_user!
	
	def dashboard
		@latest_jobs = Job.all
		@my_job = current_user.jobs
	end

end
