class ThesesController < ApplicationController
  # GET /theses
  # GET /theses.json
  def index
    @theses = Thesis.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @theses }
    end
  end

  def my_theses
    @user      = User.find_by_id(params[:id])
    @my_theses = User.theses
    render :json => { :html => render_to_string(:partial => 'my_theses') }.to_json
  end

  # GET /theses/1
  # GET /theses/1.json
  #def show
  #  @thesis = Thesis.find(params[:id])
  #
  #  respond_to do |format|
  #    format.html # show.html.erb
  #    format.json { render json: @thesis }
  #  end
  #end

  # GET /theses/new
  # GET /theses/new.json
  def new
    @thesis     = Thesis.new
    @thesis_doc = Photo.new(params[:thesis_doc])

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @thesis }
    end
  end

  # GET /theses/1/edit
  def edit
    @thesis = Thesis.find(params[:id])
  end

  # POST /theses
  # POST /theses.json
  def create_thesis
    @thesis = Thesis.new(params[:thesis])
    @thesis.update_attributes(:owner => current_user)
    unless params[:thesis_doc].blank?
     @thesis_pub            =   Photo.new(params[:thesis_doc])
     @thesis_pub.content_type = "thesis_publication"
      @thesis_pub.imageable    = @thesis
      @thesis_pub.save
    end

    respond_to do |format|
      if @thesis.save
        format.html { redirect_to @thesis, notice: 'Thesis was successfully created.' }
        format.json { render json: @thesis, status: :created, location: @thesis }
      else
        format.html { render action: "new" }
        format.json { render json: @thesis.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /theses/1
  # PUT /theses/1.json
  def update
    @thesis = Thesis.find(params[:id])

    respond_to do |format|
      if @thesis.update_attributes(params[:thesis])
        format.html { redirect_to @thesis, notice: 'Thesis was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @thesis.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /theses/1
  # DELETE /theses/1.json
  def destroy
    @thesis = Thesis.find(params[:id])
    @thesis.destroy

    respond_to do |format|
      format.html { redirect_to theses_url }
      format.json { head :ok }
    end
  end

  def download_thesis
    @thesis = Thesis.find_by_id(params[:id])
     @thesis_doc    = @thesis.photo.image
    puts "abcccccc", @thesis_doc.inspect
     send_file @thesis_doc.path
  end


end
