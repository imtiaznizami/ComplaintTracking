class SectorsController < ApplicationController
  load_and_authorize_resource :except => [:propose, :submit_proposal]

  # GET /sectors
  # GET /sectors.json
  def index
    @sectors = Sector.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sectors }
    end
  end

  # GET /sectors/1
  # GET /sectors/1.json
  def show
    @sector = Sector.includes(:antennas).find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sector }
    end
  end

  # GET /sectors/new
  # GET /sectors/new.json
  def new
    @sector = Sector.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sector }
    end
  end

  # GET /sectors/1/edit
  def edit
    @sector = Sector.find(params[:id])
  end

  def propose
    @sector = Sector.find(params[:id])
    authorize! :propose, @sector
  end

  def delme
    @sector = Sector.find(params[:id])

    @sector.assign_attributes(params[:sector])
    if params[:proposed]
      @sector.antennas.each do |antenna|
        antenna.design_status = "proposed" if antenna.changed?
      end
    end

    respond_to do |format|
      if @sector.save
        format.html { redirect_to @sector, notice: 'Sector was successfully updated.' }
        format.json { head :no_content }
      else
        if params[:proposed]
          format.html { render action: "propose" }
        else
          format.html { render action: "edit" }
        end
        format.json { render json: @sector.errors, status: :unprocessable_entity }
      end
    end
  end

  def submit_proposal
    # sector is for validation only
    # we don't want to update antenna
    # if validation pass create corresponding proposal(s)
    @sector = Sector.find(params[:id])
    @sector.assign_attributes(params[:sector])

    #TODO: make this proper / currently errors are not being caught correctly.
    #TODO: propose only if we do not already have a proposal for this antenna.
    respond_to do |format|
      if @sector.valid?
        # create proposals if values changed
        @sector.antennas.each do |antenna|
          if antenna.changed? #&& 0 == antenna.proposals.length
            proposal = Proposal.new
            proposal.antenna_id = antenna.id
            proposal.hba = antenna.hba
            proposal.azimuth = antenna.azimuth
            proposal.mechanical_tilt = antenna.mechanical_tilt
            proposal.electrical_tilt_900 = antenna.electrical_tilt_900
            proposal.electrical_tilt_1800 = antenna.electrical_tilt_1800
            proposal.electrical_tilt_2100 = antenna.electrical_tilt_2100
            proposal.design_status = "proposed"
            proposal.proposed_by = current_user
            proposal.save!
          end
        end
        format.html { redirect_to @sector, notice: 'Antenna parameters were successfully proposed.' }
        format.json { head :no_content }
      else
        format.html { render action: "propose" }
        format.json { render json: @sector.errors, status: :unprocessable_entity }
      end
    end
    authorize! :propose, @sector
  end

  # POST /sectors
  # POST /sectors.json
  def create
    @sector = Sector.new(params[:sector])

    respond_to do |format|
      if @sector.save
        format.html { redirect_to @sector, notice: 'Sector was successfully created.' }
        format.json { render json: @sector, status: :created, location: @sector }
      else
        format.html { render action: "new" }
        format.json { render json: @sector.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /sectors/1
  # PUT /sectors/1.json
  def update
    @sector = Sector.find(params[:id])

    respond_to do |format|
      if @sector.update_attributes(params[:sector])
        format.html { redirect_to @sector, notice: 'Sector was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @sector.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sectors/1
  # DELETE /sectors/1.json
  def destroy
    @sector = Sector.find(params[:id])
    @sector.destroy

    respond_to do |format|
      format.html { redirect_to sectors_url }
      format.json { head :no_content }
    end
  end
end
