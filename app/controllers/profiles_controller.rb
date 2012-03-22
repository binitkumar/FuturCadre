class ProfilesController < ApplicationController

  before_filter :authorize_user

  #def show
  #	@profile = Profile.find(params[:id])
  #end

  def new
    @profile             = Profile.new
    #    @education_info      = EducationInformation.new
    #    @job_info            = ProfessionInformation.new
    #    @resume              = Asset.new(params[:resume]) #created this for creating a resume object in the same table
    @org_photo           = Asset.new(params[:org_photo])
    @company_information = CompanyInformation.new(params[:company_information])


  end

  def upload_photo
    @photo = Asset.new(params[:asset])
    if @photo.save && @photo.errors.empty?
      session[:photo_id] = @photo.id
      render :text => "Photo is successfuly uploaded."
    else
      render :json => render_to_string(:partial => '/shared/error_messages', :locals => { :object => @photo })
    end
  end

  def create_job_seeker_basic_information
    if current_user.profile.present?
      @profile = current_user.profile
      success  = @profile.update_attributes(params[:profile])
    else
      @profile      = Profile.new(params[:profile])
      @profile.user = current_user
      success       = @profile.save
    end
    if success
      if session[:photo_id].present?
        @profile.photo.destroy if @profile.photo.present?
        photo = Asset.find_by_id(session[:photo_id])
        photo.update_attributes(:profile_id => @profile.id) if photo.present?
        session[:photo_id] = nil
      end
      @education_informations = @profile.education_informations
      @institutes             = Institute.all
      render :json => { :seccess => true, :html => render_to_string(:partial => '/profiles/job_seeker/education_details') }.to_json
    else
      render :json => { :seccess => false, :html => render_to_string(:partial => '/shared/error_messages', :locals => { :object => @profile }) }.to_json
    end
  end

  def remove_edu_info
    @profile  = Profile.find_by_id(params[:profile_id])
    @edu_info = EducationInformation.find_by_id(params[:id])
    @edu_info.destroy
    @education_informations = @profile.education_informations
    render :json => { :seccess => true, :html => render_to_string(:partial => '/profiles/job_seeker/education_informations') }.to_json
  end

  def create_job_seeker_education_details
    @institute  = Institute.new
    @institutes = Institute.all
    @profile    = Profile.find_by_id(params[:profile_id])
    @edu_info   = EducationInformation.new(params[:education_info])
    if params[:education_info][:institute_id] =="Select from list" && params[:education_info][:institute_id] =="others"
      params[:education_info][:institute_id] = nil
    else
      @edu_info.institute_id = params[:education_info][:institute_id]
    end
    @edu_info.profile       = @profile
    success                 = @edu_info.save
    @education_informations = @profile.education_informations
    if success
      render :json => { :seccess => true, :html => render_to_string(:partial => '/profiles/job_seeker/education_details') }.to_json
    else
      render :json => { :seccess => false, :html => render_to_string(:partial => '/shared/error_messages', :locals => { :object => @edu_info }) }.to_json
    end
  end

  def create_job_seeker_education_details_next
    @profile = Profile.find_by_id(params[:profile_id])
    unless params[:skip].blank?
      @edu_info = EducationInformation.new(params[:education_info])
      if params[:education_info][:institute_id] =="Select from list" && params[:education_info][:institute_id] =="others"
        params[:education_info][:institute_id] = nil
      else
        @edu_info.institute_id = params[:education_info][:institute_id]
      end
      @edu_info.profile = @profile
      success           = @edu_info.save
    else
      success = true
    end


    if success
      @professional_informations = @profile.profession_informations
      render :json => { :seccess => true, :html => render_to_string(:partial => '/profiles/job_seeker/professional_experience') }.to_json
    else
      render :json => { :seccess => false, :html => render_to_string(:partial => '/shared/error_messages', :locals => { :object => @edu_info }) }.to_json
    end
  end

  def remove_prof_info
    @profile   = Profile.find_by_id(params[:profile_id])
    @prof_info = ProfessionInformation.find_by_id(params[:id])
    @prof_info.destroy
    @professional_informations = @profile.profession_informations
    render :json => { :seccess => true, :html => render_to_string(:partial => '/profiles/job_seeker/professional_informations') }.to_json
  end

  def create_job_seeker_professional_experience
    @profile                   = Profile.find_by_id(params[:profile_id])
    @prof_info                 = ProfessionInformation.new(params[:prof_info])
    @prof_info.profile         = @profile
    success                    = @prof_info.save
    @professional_informations = @profile.profession_informations
    if success
      render :json => { :seccess => true, :html => render_to_string(:partial => '/profiles/job_seeker/professional_experience') }.to_json
    else
      render :json => { :seccess => false, :html => render_to_string(:partial => '/shared/error_messages', :locals => { :object => @prof_info }) }.to_json
    end
  end

  def create_job_seeker_professional_experience_next
    @profile = Profile.find_by_id(params[:profile_id])
    unless params[:skip].blank?
      @prof_info         = ProfessionInformation.new(params[:prof_info])
      @prof_info.profile = @profile
      success            = @prof_info.save
    else
      success = true
    end

    if params[:prof_info][:end_date]==""
      date= Time.now
    else
      date= params[:prof_info][:end_date]
    end
    @prof_info.update_attributes(:end_date=> date)

    if success
      render :json => { :seccess => true, :html => render_to_string(:partial => '/profiles/job_seeker/additional_information') }.to_json
    else
      render :json => { :seccess => false, :html => render_to_string(:partial => '/shared/error_messages', :locals => { :object => @prof_info }) }.to_json
    end
  end


  def create_job_seeker
    @profile = Profile.new(params[:profile])
    @profile.update_attributes(:user_id => current_user.id, :country_id => params[:profile][:country_id], :city_id => params[:profile][:city_id], :region_id => params[:profile][:region_id])

    @photo = params[:asset]
    unless @photo.blank?
      @asset              = Asset.new(params[:asset])
      @asset.content_type =
          @asset.user_id = current_user.id
      @asset.profile_id   = @profile.id

      unless @asset.save
        render :action => "new"
        return
      end
    end

    #educational information
    unless @profile.blank?
      @education_info            = EducationInformation.new(params[:education_info])
      @education_info.profile_id = @profile.id
      @education_info.save
    end
    #professional information
    unless @profile.blank?
      @job_information            = ProfessionInformation.new(params[:job_info])
      @job_information.profile_id =@profile.id
      @job_information.save

      @resume = params[:resume]
      unless @resume.blank?
        @cv              = Asset.new(params[:resume])
        @cv.content_type = "cv"
        @cv.user_id      = current_user.id
        @cv.profile_id   = @profile.id
        unless @cv.save
          render :action => "new"
          return
        end
      end

    end
    if @profile.save
      redirect_to(@profile, :notice => 'Profile was successfully created.')
    else
      render :action => "new"
    end
  end

  def create_employer
    @profile = Profile.new(params[:profile])
    @profile.update_attributes(:user_id => current_user.id, :country_id => params[:profile][:country_id], :city_id => params[:profile][:city_id], :region_id => params[:profile][:region_id])

    if @profile.save
      @photo = params[:asset]
      unless @photo.blank?
        @asset              = Asset.new(params[:asset])
        @asset.content_type = "profile_image"
        @asset.user_id      = current_user.id
        @asset.profile_id   = @profile.id
        unless @asset.save
          render :action => "new"
          return
        end
      end

      unless @profile.blank?
        @company_information            = CompanyInformation.new(params[:company_information])
        @company_information.country_id = params[:company_information][:country_id]
        @company_information.region_id  = params[:company_information][:region_id]
        @company_information.city_id    = params[:company_information][:city_id]
        @company_information.save

        @photo = params[:org_photo]
        unless @photo.blank?
          @image              = Asset.new(params[:org_photo])
          @image.content_type = "company_logo"
          @image.user_id      = current_user.id
          @image.profile_id   = @profile.id
          unless @image.save
            render :action => "new"
            return
          end
        end

      end

      @company_information.update_attributes(:profile_id => @profile.id)
      redirect_to(@profile, :notice => 'Profile was successfully created.')
    else
      render :action => "new"

    end
  end

  def show
    @profile = Profile.find(params[:id])
    #puts"ppppppppppppppppp", @profile.last_name.inspect
    # puts"pppppppppppppp",@profile.Sector_ids.inspect
    #puts "AAAAAAAAAAAA", @profile.locations.inspect
    #puts "BBBBBBBBBBBB", @country=Country.find_by_id(@x).inspect
    unless @profile.locations.blank?
      @ar = @profile.locations.split(",")

      if (@ar.length<3)
        @country1=Country.find_by_id(@ar[0].to_i)
        @region1 =Region.find_by_id(@ar[1].to_i)
        @city1   =City.find_by_id(@ar[2].to_i)

      elsif (@ar.length>=3) and(@ar.length<6)

        @country2=Country.find_by_id(@ar[3].to_i)
        @region2 =Region.find_by_id(@ar[4].to_i)
        @city2   =City.find_by_id(@ar[5].to_i)
      elsif (@ar.length>=6) and(@ar.length<9)

        @country3=Country.find_by_id(@ar[6].to_i)
        @region3 =Region.find_by_id(@ar[7].to_i)
        @city3   =City.find_by_id(@ar[8].to_i)
      elsif (@ar.length>=9) and(@ar.length<12)

        @country4=Country.find_by_id(@ar[9].to_i)
        @region4 =Region.find_by_id(@ar[10].to_i)
        @city4   =City.find_by_id(@ar[11].to_i)
      elsif (@ar.length>12) and(@ar.length<6)

        @country5=Country.find_by_id(@ar[12].to_i)
        @region5 =Region.find_by_id(@ar[13].to_i)
        @city5   =City.find_by_id(@ar[14].to_i)
      end

    end


    # puts"aaaaaaaaaaaaaaaaaa",@country1.name.inspect
    # puts"aaaaaaaaaaaaaaaaaa",@region1.name.inspect
    #puts"aaaaaaaaaaaaaaaaaa",@city1.name.inspect
    #puts"cccccccccccccccccc",@country2.name.inspect
    #puts"cccccccccccc",@region2.name.inspect
    #puts"cccccccccccc",@city2.name.inspect
    # puts"aaaaaaaaaaaaaaaaa",@country1.country.name.inspect
    # puts "aaaaaa", @ar[1].inspect
    #puts"bbbbbbb",@ar.length.inspect
    #puts "EEEEEEEEEEE", @profile.locations.length.inspect
    @image =""
    @profile.assets.each do |asset|
      if asset.content_type == "profile_image"
        @image << asset.photo.url
      end
    end
  end

  def edit
    @profile                 = Profile.find(params[:id])
    @company_information     = @profile.company_information
    @asset                   = @profile.assets.where("content_type =?", "profile_image")
    @profession_informations = @profile.profession_informations
    @resume                  = @profile.assets.where("content_type =?", "cv")
    @org_photo               = @profile.assets.where("content_type =?", "logo")
    @education_informations  = @profile.education_informations
    @city                    = @profile.city
    @regions                 = @city.country.regions
    @region                  = @profile.region
    @cities                  = @region.cities
    @country                 = @city.country
  end

  def update_employer
    @profile             = Profile.find_by_id(params[:id])
    @company_information = CompanyInformation.find_by_id(params[:comp_id])
    #@asset = @profile.assets.where("content_type =?", "profile_image").first
    if @profile.update_attributes(params[:profile])
      @company_information.update_attributes(params[:company_information])
      unless params[:asset].blank?
        @profile.assets.each do |img|
          if img.content_type == "profile_image"
            img.update_attributes(params[:asset])
          end
        end
      end
      unless params[:org_photo].blank?
        @profile.assets.each do |logo|
          if logo.content_type == "company_logo"
            logo.update_attributes(params[:org_photo])
          end
        end
      end
      redirect_to @profile, :notice => 'Profile was successfully updated.'
    else
      render :action => "edit"
    end
  end

  def update_job_seeker
    @profile        = Profile.find_by_id(params[:id])
    @job_info       = ProfessionInformation.find_by_id(params[:job_id])
    @education_info = EducationInformation.find_by_id(params[:edu_id])

    if @profile.update_attributes(params[:profile])
      @education_info.update_attributes(params[:education_info])
      @job_info.update_attributes(params[:job_info])

      unless @profile.assets.each do |img|
        if img.content_type == "profile_image"
          img.update_attributes(params[:asset])
        end
      end
      end
      unless params[:resume].blank?
        @profile.assets.each do |cv|
          if cv.content_type == "cv"
            cv.update_attributes(params[:resume])
          end
        end
      end
      redirect_to @profile, :notice => 'Profile was successfully updated.'
    else
      render :action => "edit"
    end
  end


  def create_institute
    @institute = Institute.new(params[:institute])
    if @institute.save
      @institutes = Institute.all
      render :json => { :seccess => true, :html => render_to_string(:partial => '/profiles/job_seeker/institute_list'), :locals => { :institutes => @institutes } }.to_json
    end
  end


  def create_job_seeker_additional_information

    @profile = Profile.find_by_id(params[:profile_id])

    if params[:date_of_start]=="true"
      date= Time.now
    else
      date= params[:date_of_start_text]
    end


    unless params[:add_info][:country_id].blank?
      location=params[:add_info][:country_id] +','+params[:add_info][:region_id]+','+params[:add_info][:city_id]
    end

    unless params[:add_info][:country_id_1].blank?
      location1= params[:add_info][:country_id_1] +','+params[:add_info][:regions_add_1]+','+params[:add_info][:cities_add_1]
      location =location+','+location1
    else
      location=location
    end
    unless params[:add_info][:country_id_2].blank?
      location2= params[:add_info][:country_id_2] +','+params[:add_info][:regions_add_2]+','+params[:add_info][:cities_add_2]
      location =location+','+location2
    else
      location=location
    end

    unless params[:add_info][:country_id_3].blank?
      location3= params[:add_info][:country_id_3] +','+params[:add_info][:regions_add_3]+','+params[:add_info][:cities_add_3]
      location =location+','+location3
    else
      location=location
    end

    unless params[:add_info][:country_id_4].blank?
      location4= params[:add_info][:country_id_4] +','+params[:add_info][:regions_add_4]+','+params[:add_info][:cities_add_4]
      location =location+','+location4
    else
      location=location
    end

    @ar = params[:sector_ids]

    if (@ar.length==1)
      sector=@ar[0]
    end
    if (@ar.length==2)
      sector =@ar[0]
      sector2=@ar[1]
      sector =sector+','+sector2
    end
    if (@ar.length==3)
      sector =@ar[0]
      sector2=@ar[1]
      sector3=@ar[2]
      sector =sector+','+sector2+','+sector3
    end
    if (@ar.length==4)
      sector =@ar[0]
      sector2=@ar[1]
      sector3=@ar[2]
      sector4=@ar[3]
      sector =sector+','+sector2+','+sector3+','+sector4
    end
    if (@ar.length==5)
      sector =@ar[0]
      sector2=@ar[1]
      sector3=@ar[2]
      sector4=@ar[3]
      sector5=@ar[4]
      sector =sector+','+sector2+','+sector3+','+sector4+','+sector5

    end


    @profile.update_attributes(:job_title => params[:job_title], :Sector_ids =>sector, :locations => location, :date_of_start => date, :work_authorization => params[:work_authorization], :desired_job_type => params[:desired_job_type], :desired_job_status => params[:desired_job_status], :salary_to => params[:salary_to], :salary_from => params[:salary_from], :currency => params[:currency], :salary_period => params[:salary_period], :willing => params[:willing], :willing_to_travel => params[:willing_to_travel])

    redirect_to @profile, :notice => 'Profile was successfully updated.'
  end

end

