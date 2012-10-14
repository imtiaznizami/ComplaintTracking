class AntennasController < ApplicationController
  # GET /antennas
  # GET /antennas.json
  def index
    @antennas = Antenna.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @antennas }
    end
  end

  # GET /antennas/1
  # GET /antennas/1.json
  def show
    @antenna = Antenna.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @antenna }
    end
  end

  # GET /antennas/new
  # GET /antennas/new.json
  def new
    @antenna = Antenna.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @antenna }
    end
  end

  # GET /antennas/1/edit
  def edit
    @antenna = Antenna.find(params[:id])
  end

  # POST /antennas
  # POST /antennas.json
  def create
    @antenna = Antenna.new(params[:antenna])

    respond_to do |format|
      if @antenna.save
        format.html { redirect_to @antenna, notice: 'Antenna was successfully created.' }
        format.json { render json: @antenna, status: :created, location: @antenna }
      else
        format.html { render action: "new" }
        format.json { render json: @antenna.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /antennas/1
  # PUT /antennas/1.json
  def update
    @antenna = Antenna.find(params[:id])

    respond_to do |format|
      if @antenna.update_attributes(params[:antenna])
        format.html { redirect_to @antenna, notice: 'Antenna was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @antenna.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /antennas/1
  # DELETE /antennas/1.json
  def destroy
    @antenna = Antenna.find(params[:id])
    @antenna.destroy

    respond_to do |format|
      format.html { redirect_to antennas_url }
      format.json { head :no_content }
    end
  end
end
