class RecordersController < ApplicationController
  # GET /recorders
  # GET /recorders.json
  def index
    @recorders = Recorder.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @recorders }
    end
  end

  # GET /recorders/1
  # GET /recorders/1.json
  def show
    @recorder = Recorder.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @recorder }
    end
  end

  # GET /recorders/new
  # GET /recorders/new.json
  def new
    @recorder = Recorder.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @recorder }
    end
  end

  # GET /recorders/1/edit
  def edit
    @recorder = Recorder.find(params[:id])
  end

  # POST /recorders
  # POST /recorders.json
  def create
    @recorder = Recorder.new(params[:recorder])

    respond_to do |format|
      if @recorder.save
        format.html { redirect_to @recorder, notice: 'Recorder was successfully created.' }
        format.json { render json: @recorder, status: :created, location: @recorder }
      else
        format.html { render action: "new" }
        format.json { render json: @recorder.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /recorders/1
  # PUT /recorders/1.json
  def update
    @recorder = Recorder.find(params[:id])

    respond_to do |format|
      if @recorder.update_attributes(params[:recorder])
        format.html { redirect_to @recorder, notice: 'Recorder was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @recorder.errors, status: :unprocessable_entity }
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
end
