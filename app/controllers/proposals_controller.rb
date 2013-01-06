class ProposalsController < ApplicationController
  #TODO: localhost:3000/proposals should not result in RedirectBackError when no user is logged in
  load_and_authorize_resource :except => :commit

  # GET /proposals
  # GET /proposals.json
  def index
    @proposals = Proposal.where(:design_status => "proposed")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @proposals }
    end
  end

  # GET /proposals/1
  # GET /proposals/1.json
  def show
    @proposal = Proposal.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @proposal }
    end
  end

  # GET /proposals/new
  # GET /proposals/new.json
  def new
    @proposal = Proposal.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @proposal }
    end
  end

  # GET /proposals/1/edit
  def edit
    @proposal = Proposal.find(params[:id])
  end

  # POST /proposals
  # POST /proposals.json
  def create
    @proposal = Proposal.new(params[:proposal])

    respond_to do |format|
      if @proposal.save
        format.html { redirect_to @proposal, notice: 'Proposal was successfully created.' }
        format.json { render json: @proposal, status: :created, location: @proposal }
      else
        format.html { render action: "new" }
        format.json { render json: @proposal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /proposals/1
  # PUT /proposals/1.json
  def update
    @proposal = Proposal.find(params[:id])

    respond_to do |format|
      if @proposal.update_attributes(params[:proposal])
        format.html { redirect_to @proposal, notice: 'Proposal was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @proposal.errors, status: :unprocessable_entity }
      end
    end
  end

  def commit
    @proposal = Proposal.find(params[:id])

    antenna = Antenna.find(@proposal.antenna)
    antenna.attributes = {
      :hba => @proposal.hba,
      :azimuth => @proposal.azimuth,
      :mechanical_tilt => @proposal.mechanical_tilt,
      :electrical_tilt_900 => @proposal.electrical_tilt_900,
      :electrical_tilt_1800 => @proposal.electrical_tilt_1800,
      :electrical_tilt_2100 => @proposal.electrical_tilt_2100,

      :proposals_attributes => [
        { :id => @proposal.id, :committed_by => current_user.id, :committed_at => Time.now,  :design_status => "committed" }
      ]
    }

    respond_to do |format|
      if antenna.save
        #format.html { redirect_to @proposal, notice: 'Proposal was successfully updated.' }
        format.html { redirect_to :proposals, :notice => 'Proposal was successfully committed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to :proposals }
        format.json { render json: @proposal.errors, status: :unprocessable_entity }
      end
    end
    authorize! :commit, @proposal
  end

  # DELETE /proposals/1
  # DELETE /proposals/1.json
  def destroy
    @proposal = Proposal.find(params[:id])
    @proposal.destroy

    respond_to do |format|
      format.html { redirect_to proposals_url }
      format.json { head :no_content }
    end
  end
end
