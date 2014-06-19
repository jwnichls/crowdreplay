class RecordersController < ApplicationController
  before_filter :require_admin

  # GET /recorders
  # GET /recorders.json
  def index
    @recorders = Recorder.all
  end

  # GET /recorders/new
  # GET /recorders/new.json
  def new
    if session[:recorder] and session[:recorder].id == nil
      @recorder = session[:recorder]
      session[:recorder] = nil
    else
      @recorder = Recorder.new
      session[:recorder] = nil
    end

    process_auth_tokens(session)
  end

  # GET /recorders/1/edit
  def edit
    if session[:recorder] and session[:recorder].id != nil
      @recorder = session[:recorder]
      session[:recorder] = nil
    else
      @recorder = Recorder.find(params[:id])
      session[:recorder] = nil
    end
    
    process_auth_tokens(session)
    
    session[:recorder_state] = "edit"
    session[:auth_redirect] = url_for edit_recorder_path(@recorder)
  end

  def auth_redirect
    auth = request.env["omniauth.auth"]
    session[:access_token] = auth['credentials'].token
    session[:access_secret] = auth['credentials'].secret
    
    redirect_to session[:auth_redirect]
  end

  # POST /recorders
  # POST /recorders.json
  def create
    @recorder = Recorder.new(params[:recorder])
    @recorder.status = "Stopped"
    @recorder.running = false

    if params[:commit] == "Select Twitter Account"
      session[:recorder] = @recorder
      session[:auth_redirect] = new_recorder_path
      
      redirect_to '/auth/twitter'
    else
      if @recorder.save
        redirect_to recorders_path
      else
        render :action => "new"
      end
    end
  end

  # PUT /recorders/1
  # PUT /recorders/1.json
  def update
    @recorder = Recorder.find(params[:id])
    @recorder.assign_attributes(params[:recorder])
    
    if params[:commit] == "Select Twitter Account"
      session[:recorder] = @recorder
      session[:auth_redirect] = edit_recorder_path(@recorder)
    
      redirect_to '/auth/twitter'
    else
      if @recorder.save
        redirect_to recorders_path
      else
        render :action => "edit"
      end
    end
  end

  # DELETE /recorders/1
  # DELETE /recorders/1.json
  def destroy
    @recorder = Recorder.find(params[:id])
    @recorder.destroy

    respond_to do |format|
      format.html { redirect_to recorders_url }
      format.json { head :no_content }
    end
  end
  
  def start
    @recorder = Recorder.find(params[:id])
    
    if @recorder.status == "Stopped" or @recorder.status == "Stopping"
      @recorder.status = "Starting"
      @recorder.save
    end
    
    redirect_to recorders_path
  end
  
  def stop
    @recorder = Recorder.find(params[:id])
    
    if @recorder.status == "Starting" or @recorder.status == "Running"
      @recorder.status = "Stopping"
      @recorder.save
    end
    
    redirect_to recorders_path
  end
  
  private
  
  def process_auth_tokens(session)
    if session[:access_token] and session[:access_secret]
      @recorder.oauth_access_token = session[:access_token]
      @recorder.oauth_access_secret = session[:access_secret]
      @recorder.set_screenname
      
      session[:access_token] = nil
      session[:access_secret] = nil
    end
  end
end
