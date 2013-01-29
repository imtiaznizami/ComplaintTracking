class Antenna < ActiveRecord::Base
  attr_accessible :band, :vendor, :code, :hba, :azimuth, :mechanical_tilt,
    :electrical_tilt_900, :electrical_tilt_1800, :electrical_tilt_2100,
    :design_status, :sector_id, :id,
    :proposals_attributes,
    :effective_tilt_900, :effective_tilt_1800

  # Validations
  #validate :count_within_limit
  validate :correct_band_populated
  validate :correct_antenna_band_and_tilts
  # Following line is commented out to create antenna along with sector creation (pecularities due to use of nested_attributes)
  #validates_presence_of :sector_id
  validates_presence_of :code
  validates_numericality_of :azimuth, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 360, :allow_nil => true
  validates_numericality_of :hba, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100, :allow_nil => true
  validates_numericality_of :mechanical_tilt, :greater_than_or_equal_to => -14, :less_than_or_equal_to => 100, :allow_nil => true


  # Relations
  belongs_to :sector
  has_many :proposals
  #has_paper_trail :ignore => [:updated_at, :created_at]

  accepts_nested_attributes_for :proposals, :reject_if => :all_blank, :allow_destroy => true


  # Custom methods
  def count_within_limit
    if self.sector.antennas(:reload).count > 2
      errors.add(:base, "Error: We can only have two antennas per sector.")
    end
  end

  def correct_band_populated
    unless ( ( band == "900" && (electrical_tilt_1800.blank? && electrical_tilt_2100.blank?) ) ||
             ( band == "1800" && (electrical_tilt_900.blank? && electrical_tilt_2100.blank?) ) ||
             ( band == "Dual" && (electrical_tilt_2100.blank?) ) )
      errors.add(:base, "Error: Electrical tilt entered is for the wrong band.#{code}")
    end
  end

  Specs = Struct.new(:band, :electrical_tilt_900_upper, :electrical_tilt_1800_upper)
  def correct_antenna_band_and_tilts
    antenna_specs = {
      "Andrew: DB874G35A-XY" => Specs.new("1800", nil, nil),
      "Andrew: HBX-6516DS-VTM" => Specs.new("1800", nil, 10.0),
      "Andrew: HBX-6517DS-VTM" => Specs.new("1800", nil, 6.0),
      "Andrew: HBX-9014DS-VTM" => Specs.new("1800", nil, 10.0),
      "Andrew: HBXX-6516DS-VTM" => Specs.new("1800", nil, 10.0),
      "Andrew: HBXX-6517DS-VTM" => Specs.new("1800", nil, 6.0),
      "Andrew: DBXLH-6565A-VTM" => Specs.new("Dual", 15.0, 8.0),
      "Andrew: DBXLH-6565B-VTM" => Specs.new("Dual", 10.0, 6.0),
      "Andrew: DBXLH-6565C-VTM" => Specs.new("Dual", 8.0, 6.0),
      "Andrew: LBX-3319DS-VTM" => Specs.new("900", 8.0, nil),
      "Andrew: LBX-6513DS-VTM" => Specs.new("900", 15.0, nil),
      "Andrew: LBX-6516DS-VTM" => Specs.new("900", 8.0, nil),
      "Andrew: LBX-9013DS-VTM" => Specs.new("900", 10.0, nil),
      "Andrew: LBXX-6516DS-VTM" => Specs.new("900", 8.0, nil),
      "Kathrein: 80010137" => Specs.new("Dual", nil, nil),
      "Kathrein: 741989" => Specs.new("1800", nil, 8.0),
      "Kathrein: 742212" => Specs.new("1800", nil, 8.0),
      "Kathrein: 742213" => Specs.new("1800", nil, 6.0),
      "Kathrein: 742215" => Specs.new("1800", nil, 10.0),
      "Kathrein: 742265" => Specs.new("Dual", 10.0, 6.0),
      "Kathrein: 742266" => Specs.new("Dual", 7.0, 6.0),
      "Kathrein: 80010248" => Specs.new("Dual", nil, nil),
      "Kathrein: 739665" => Specs.new("900", 10.0, nil),
      "Kathrein: 739684" => Specs.new("900", 14.0, nil),
      "Kathrein: 739686" => Specs.new("900", 7.0, nil),
      "Kathrein: K7345647" => Specs.new("900", 10.0, nil),
      "Mobi: MB6F-03 5-c-i-s" => Specs.new("Dual", nil, nil),
      "Mobi: MB3F-65-18DE10" => Specs.new("1800", nil, 10.0),
      "Mobi: MB3F-65-20DE" => Specs.new("1800", nil, 10.0),
      "Mobi: MB3F-90-17DE" => Specs.new("1800", nil, 10.0),
      "Mobi: MB3BH/3F-65-16/17DE" => Specs.new("Dual", 10.0, 8.0),
      "Mobi: MB3BH/3F-65-17/18DE" => Specs.new("Dual", 10.0, 8.0),
      "Mobi: MB3BH-3F-65-14/17DE" => Specs.new("Dual", 14.0, 10.0),
      "Mobi: MB7f-d7/9-wc-001" => Specs.new("Dual", 0.0, 0.0),
      "Mobi: MB3BH-65-15DE" => Specs.new("900", 14.0, nil),
      "Mobi: MB3BH-65-18-DDE" => Specs.new("900", 12.0, nil),
      "Mobi: MB3BH-65-18-DE" => Specs.new("900", 12.0, nil),
      "Mobi: MB3BH-90-16.5DE10" => Specs.new("900", 10.0, nil),
      "Indoor" => Specs.new("Dual", 0.0, 0.0)
    }

    unless (antenna_specs[code].band == band)
      errors.add(:base, "Error: Selected antenna supports bands: #{antenna_specs[code].band}")
    end

    unless (electrical_tilt_900.nil?)
      if ( antenna_specs[code].electrical_tilt_900_upper.nil? or electrical_tilt_900 < 0 or electrical_tilt_900 > antenna_specs[code].electrical_tilt_900_upper )
        errors.add(:base, "Error: Selected antenna's 900 tilt range is: 0-#{antenna_specs[code].electrical_tilt_900_upper||0.to_s}")
      end
    end

    unless (electrical_tilt_1800.nil?)
      if ( antenna_specs[code].electrical_tilt_1800_upper.nil? or electrical_tilt_1800 < 0 or electrical_tilt_1800 > antenna_specs[code].electrical_tilt_1800_upper )
        errors.add(:base, "Error: Selected antenna's 1800 tilt range is: 0-#{antenna_specs[code].electrical_tilt_1800_upper||0.to_s}")
      end
    end
  end

  def effective_tilt_900
    if (mechanical_tilt || electrical_tilt_900).nil?
      nil
    else
      mechanical_tilt.to_i + electrical_tilt_900.to_i
    end
  end

  def effective_tilt_1800
    if (mechanical_tilt || electrical_tilt_1800).nil?
      nil
    else
      mechanical_tilt.to_i + electrical_tilt_1800.to_i
    end
  end

  # Constants
  #BANDS = ["900", "1800", "2100", "Dual", "Tri"]
  BANDS = ["900", "1800", "Dual"]

  ANTENNA_TYPES = [ "Andrew: DB874G35A-XY", "Andrew: HBX-6516DS-VTM",
                    "Andrew: HBX-6517DS-VTM", "Andrew: HBX-9014DS-VTM",
                    "Andrew: HBXX-6516DS-VTM",
                    "Andrew: HBXX-6517DS-VTM",
                    "Andrew: DBXLH-6565A-VTM", "Andrew: DBXLH-6565B-VTM",
                    "Andrew: DBXLH-6565C-VTM",
                    "Andrew: LBX-3319DS-VTM",
                    "Andrew: LBX-6513DS-VTM",
                    "Andrew: LBX-6516DS-VTM", "Andrew: LBX-9013DS-VTM",
                    "Andrew: LBXX-6516DS-VTM", "Kathrein: 80010137",
                    "Kathrein: 741989", "Kathrein: 742212",
                    "Kathrein: 742213",
                    "Kathrein: 742215", "Kathrein: 742265",
                    "Kathrein: 742266", "Kathrein: 80010248",
                    "Kathrein: 739665", "Kathrein: 739684",
                    "Kathrein: 739686",
                    "Kathrein: K7345647",
                    "Mobi: MB6F-03 5-c-i-s",
                    "Mobi: MB3F-65-18DE10", "Mobi: MB3F-65-20DE",
                    "Mobi: MB3F-90-17DE", "Mobi: MB3BH/3F-65-16/17DE",
                    "Mobi: MB3BH/3F-65-17/18DE", "Mobi: MB3BH-3F-65-14/17DE",
                    "Mobi: MB7f-d7/9-wc-001", "Mobi: MB3BH-65-15DE",
                    "Mobi: MB3BH-65-18-DDE", "Mobi: MB3BH-65-18-DE",
                    "Mobi: MB3BH-90-16.5DE10",
                    "Indoor"
  ]


  #

end
