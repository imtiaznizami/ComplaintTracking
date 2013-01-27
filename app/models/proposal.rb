class Proposal < ActiveRecord::Base
  attr_accessible :band, :code, :hba, :azimuth, :mechanical_tilt,
    :electrical_tilt_900, :electrical_tilt_1800, :electrical_tilt_2100,
    :design_status, :antenna_id, :proposed_at, :proposed_by,
    :committed_at, :committed_by, :id, :created_at, :updated_at

  belongs_to :antenna
end
