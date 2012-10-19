class Antenna < ActiveRecord::Base

  # Validations
  #validate :count_within_limit
  validate :correct_band_populated
  validate :correct_antenna_band
  validate :correct_antenna_tilts
  validates_presence_of :sector_id
  validates_numericality_of :azimuth, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 360, :allow_nil => true
  validates_numericality_of :hba, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100, :allow_nil => true
  validates_numericality_of :mechanical_tilt, :greater_than_or_equal_to => -14, :less_than_or_equal_to => 14, :allow_nil => true


  # Relations
  belongs_to :sector
  #has_paper_trail :ignore => [:updated_at, :created_at]


  # Custom methods
  def count_within_limit
    if self.sector.antennas(:reload).count > 2
      errors.add(:base, "Error: We can only have two antennas per sector.")
    end
  end

  def correct_band_populated
    unless ( ( band == "900" && (electrical_tilt_1800.blank? && electrical_tilt_2100.blank?) ) ||
             ( band == "1800" && (electrical_tilt_900.blank? && electrical_tilt_2100.blank?) ) )
      errors.add(:base, "Error: Electrical tilt entered is for the wrong band.")
    end
  end

  def correct_antenna_band
    unless (@@antenna_specs[code].band == band)
      errors.add(:base, "Error: Selected antenna does not support selected band.")
    end
  end

  def correct_antenna_tilts
    unless (electrical_tilt_900.nil?)
      if ( @@antenna_specs[code].electrical_tilt_900_upper.nil? or electrical_tilt_900 < 0 or electrical_tilt_900 > @@antenna_specs[code].electrical_tilt_900_upper )
        errors.add(:base, "Error: Selected antenna does not support selected 900 tilt.")
      end
    end

    unless (electrical_tilt_1800.nil?)
      if ( @@antenna_specs[code].electrical_tilt_1800_upper.nil? or electrical_tilt_1800 < 0 or electrical_tilt_1800 > @@antenna_specs[code].electrical_tilt_1800_upper )
        errors.add(:base, "Error: Selected antenna does not support selected 1800 tilt.")
      end
    end
  end


  # Constants
  #BANDS = ["900", "1800", "2100", "Dual", "Tri"]
  BANDS = ["900", "1800", "Dual"]

  ANTENNA_TYPES = [ "Andrew: DB874G35A-XY", "Andrew: HBX-6516DS-VTM",
                    "Andrew: HBX-6517DS-VTM", "Andrew: HBX-9014DS-VTM",
                    "Andrew: DBXLH-6565A-VTM", "Andrew: DBXLH-6565B-VTM",
                    "Andrew: DBXLH-6565C-VTM", "Andrew: LBX-6513DS-VTM",
                    "Andrew: LBX-6516DS-VTM", "Andrew: LBX-9013DS-VTM",
                    "Andrew: LBXX-6516DS-VTM", "Kathrein: 80010137",
                    "Kathrein: 741989", "Kathrein: 742213",
                    "Kathrein: 742215", "Kathrein: 742265",
                    "Kathrein: 742266", "Kathrein: 80010248",
                    "Kathrein: 739665", "Kathrein: 739684",
                    "Kathrein: 739686", "Mobi: MB6F-03 5-c-i-s",
                    "Mobi: MB3F-65-18DE10", "Mobi: MB3F-65-20DE",
                    "Mobi: MB3F-90-17DE", "Mobi: MB3BH/3F-65-16/17DE",
                    "Mobi: MB3BH/3F-65-17/18DE", "Mobi: MB3BH-3F-65-14/17DE",
                    "Mobi: MB7f-d7/9-wc-001", "Mobi: MB3BH-65-15DE",
                    "Mobi: MB3BH-65-18-DDE", "Mobi: MB3BH-65-18-DE",
                    "Mobi: MB3BH-90-16.5DE10" ]


  #
  Specs = Struct.new(:band, :electrical_tilt_900_upper, :electrical_tilt_1800_upper)
  @@antenna_specs = {
    "Andrew: DB874G35A-XY" => Specs.new("1800", nil, nil),
    "Andrew: HBX-6516DS-VTM" => Specs.new("1800", nil, 10.0),
    "Andrew: HBX-6517DS-VTM" => Specs.new("1800", nil, 6.0),
    "Andrew: HBX-9014DS-VTM" => Specs.new("1800", nil, 10.0),
    "Andrew: DBXLH-6565A-VTM" => Specs.new("dual", 15.0, 8.0),
    "Andrew: DBXLH-6565B-VTM" => Specs.new("dual", 10.0, 6.0),
    "Andrew: DBXLH-6565C-VTM" => Specs.new("dual", 8.0, 6.0),
    "Andrew: LBX-6513DS-VTM" => Specs.new("900", 15.0, nil),
    "Andrew: LBX-6516DS-VTM" => Specs.new("900", 8.0, nil),
    "Andrew: LBX-9013DS-VTM" => Specs.new("900", 10.0, nil),
    "Andrew: LBXX-6516DS-VTM" => Specs.new("900", 8.0, nil),
    "Kathrein: 80010137" => Specs.new("dual", nil, nil),
    "Kathrein: 741989" => Specs.new("1800", nil, 8.0),
    "Kathrein: 742213" => Specs.new("1800", nil, 6.0),
    "Kathrein: 742215" => Specs.new("1800", nil, 10.0),
    "Kathrein: 742265" => Specs.new("dual", 10.0, 6.0),
    "Kathrein: 742266" => Specs.new("dual", 7.0, 6.0),
    "Kathrein: 80010248" => Specs.new("dual", nil, nil),
    "Kathrein: 739665" => Specs.new("900", 10.0, nil),
    "Kathrein: 739684" => Specs.new("900", 14.0, nil),
    "Kathrein: 739686" => Specs.new("900", 7.0, nil),
    "Mobi: MB6F-03 5-c-i-s" => Specs.new("dual", nil, nil),
    "Mobi: MB3F-65-18DE10" => Specs.new("1800", nil, 10.0),
    "Mobi: MB3F-65-20DE" => Specs.new("1800", nil, 10.0),
    "Mobi: MB3F-90-17DE" => Specs.new("1800", nil, 10.0),
    "Mobi: MB3BH/3F-65-16/17DE" => Specs.new("dual", 10.0, 8.0),
    "Mobi: MB3BH/3F-65-17/18DE" => Specs.new("dual", 10.0, 8.0),
    "Mobi: MB3BH-3F-65-14/17DE" => Specs.new("dual", 14.0, 10.0),
    "Mobi: MB7f-d7/9-wc-001" => Specs.new("dual", 0.0, 0.0),
    "Mobi: MB3BH-65-15DE" => Specs.new("900", 14.0, nil),
    "Mobi: MB3BH-65-18-DDE" => Specs.new("900", 12.0, nil),
    "Mobi: MB3BH-65-18-DE" => Specs.new("900", 12.0, nil),
    "Mobi: MB3BH-90-16.5DE10" => Specs.new("900", 10.0, nil)
  }

end
