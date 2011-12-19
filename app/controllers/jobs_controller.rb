class JobsController < ApplicationController

	def show
    @job = Job.find_by_id(params[:id])
	end

	def details
		@job = Job.find_by_id(params[:id])
		render :json => {:html => render_to_string(:partial => '/jobs/details')}.to_json
  end



  def new
    @job= Job.new
    @skill = Skill.new(params[:skills])
    @responsibility = Responsibility.new(params[:respon])

  end

  def create_job
    @job = Job.new(params[:job])
    @job.update_attributes(:employer_id => current_user.id, :country_id=> params[:country_id], :region_id=>params[:region_id],
                           :city_id     =>params[:city_id], :category_id => params[:category_id])

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
    @job.skills << Skill.find_by_id(@skill_new.id)
    @job.responsibilities << Responsibility.find_by_id(@responsibility.id)

    if @job.save
      redirect_to(@job, :notice => 'Job was successfully created.')
    else
      render :action => "new"
    end
  end

end


