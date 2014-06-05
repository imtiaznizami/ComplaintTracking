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
    unless ( 
             ( band == "900" && (electrical_tilt_1800.blank? && electrical_tilt_2100.blank?) ) ||
             ( band == "1800" && (electrical_tilt_900.blank? && electrical_tilt_2100.blank?) ) ||
             ( band == "2100" && (electrical_tilt_900.blank? && electrical_tilt_1800.blank?) ) ||
             ( band == "Dual_900_1800" && (electrical_tilt_2100.blank?) ) ||
             ( band == "Dual_1800_2100" && (electrical_tilt_900.blank?) ) ||
             ( band == "Double_1800_1800" && (electrical_tilt_900.blank? && electrical_tilt_2100.blank?) ) ||
             ( band == "Double_1800_2100" && (electrical_tilt_900.blank?) ) ||
             ( band == "Tri_900_1800_1800" && (electrical_tilt_2100.blank?) ) ||
             ( band == "Tri_900_1800_2100" )
           )
      errors.add(:base, "Error: Electrical tilt entered is for the wrong band.#{code}")
    end
  end

  Specs = Struct.new(:band, :electrical_tilt_900_upper, :electrical_tilt_1800_upper)
  def correct_antenna_band_and_tilts
    antenna_specs = {
      'Andrew: DB874G35A-XY' => {:bands => ['1800', '2100'], :etilt_900_upper => nil, :etilt_1800_upper => nil, :etilt_2100_upper => nil},
      'Andrew: HBX-6516DS-VTM' => {:bands => ['1800', '2100'], :etilt_900_upper => nil, :etilt_1800_upper => 10.0, :etilt_2100_upper => 10.0},
      'Andrew: HBX-6517DS-VTM' => {:bands => ['1800', '2100'], :etilt_900_upper => nil, :etilt_1800_upper => 6.0, :etilt_2100_upper => 6.0},
      'Andrew: HBX-9014DS-VTM' => {:bands => ['1800', '2100'], :etilt_900_upper => nil, :etilt_1800_upper => 10.0, :etilt_2100_upper => 10.0},
      'Andrew: HBXX-6516DS-VTM' => {:bands => ['Double_1800_1800', 'Double_1800_2100'], :etilt_900_upper => nil, :etilt_1800_upper => 10.0, :etilt_2100_upper => 10.0},
      'Andrew: DBXLH-6565A-VTM' => {:bands => ['Dual_900_1800'], :etilt_900_upper => 15.0, :etilt_1800_upper => 8.0, :etilt_2100_upper => 8.0},
      'Andrew: DBXLH-6565B-VTM' => {:bands => ['Dual_900_1800'], :etilt_900_upper => 10.0, :etilt_1800_upper => 6.0, :etilt_2100_upper => 6.0},
      'Andrew: DBXLH-6565C-VTM' => {:bands => ['Dual_900_1800'], :etilt_900_upper => 8.0, :etilt_1800_upper => 6.0, :etilt_2100_upper => 6.0},
      'Andrew: LBX-3319DS-VTM' => {:bands => ['900'], :etilt_900_upper => 8.0, :etilt_1800_upper => nil, :etilt_2100_upper => nil},
      'Andrew: LBX-6513DS-VTM' => {:bands => ['900'], :etilt_900_upper => 15.0, :etilt_1800_upper => nil, :etilt_2100_upper => nil},
      'Andrew: LBX-6516DS-VTM' => {:bands => ['900'], :etilt_900_upper => 8.0, :etilt_1800_upper => nil, :etilt_2100_upper => nil},
      'Andrew: LBX-9013DS-VTM' => {:bands => ['900'], :etilt_900_upper => 10.0, :etilt_1800_upper => nil, :etilt_2100_upper => nil},
      'Andrew: LBXX-6516DS-VTM' => {:bands => ['900'], :etilt_900_upper => 8.0, :etilt_1800_upper => nil, :etilt_2100_upper => nil},
      'Kathrein: 80010137' => {:bands => ['Dual_900_1800'], :etilt_900_upper => nil, :etilt_1800_upper => nil, :etilt_2100_upper => nil},
      'Kathrein: 741989' => {:bands => ['1800', '2100'], :etilt_900_upper => nil, :etilt_1800_upper => 8.0, :etilt_2100_upper => 8.0},
      'Kathrein: 742212' => {:bands => ['1800', '2100'], :etilt_900_upper => nil, :etilt_1800_upper => 8.0, :etilt_2100_upper => 8.0},
      'Kathrein: 742213' => {:bands => ['1800', '2100'], :etilt_900_upper => nil, :etilt_1800_upper => 6.0, :etilt_2100_upper => 6.0},
      'Kathrein: 742215' => {:bands => ['1800', '2100'], :etilt_900_upper => nil, :etilt_1800_upper => 10.0, :etilt_2100_upper => 10.0},
      'Kathrein: 742265' => {:bands => ['Dual_900_1800'], :etilt_900_upper => 10.0, :etilt_1800_upper => 6.0, :etilt_2100_upper => 6.0},
      'Kathrein: 742266' => {:bands => ['Dual_900_1800'], :etilt_900_upper => 7.0, :etilt_1800_upper => 6.0, :etilt_2100_upper => 6.0},
      'Kathrein: 80010248' => {:bands => ['Dual_900_1800'], :etilt_900_upper => nil, :etilt_1800_upper => nil, :etilt_2100_upper => nil},
      'Kathrein: 739665' => {:bands => ['900'], :etilt_900_upper => 10.0, :etilt_1800_upper => nil, :etilt_2100_upper => nil},
      'Kathrein: 739684' => {:bands => ['900'], :etilt_900_upper => 14.0, :etilt_1800_upper => nil, :etilt_2100_upper => nil},
      'Kathrein: 739686' => {:bands => ['900'], :etilt_900_upper => 7.0, :etilt_1800_upper => nil, :etilt_2100_upper => nil},
      'Kathrein: K7345647' => {:bands => ['900'], :etilt_900_upper => 10.0, :etilt_1800_upper => nil, :etilt_2100_upper => nil},
      'Mobi: MB6F-03 5-c-i-s' => {:bands => ['Dual_900_1800'], :etilt_900_upper => nil, :etilt_1800_upper => nil, :etilt_2100_upper => nil},
      'Mobi: MB3F-65-18DE10' => {:bands => ['1800', '2100'], :etilt_900_upper => nil, :etilt_1800_upper => 10.0, :etilt_2100_upper => 10.0},
      'Mobi: MB3F-65-20DE' => {:bands => ['1800', '2100'], :etilt_900_upper => nil, :etilt_1800_upper => 10.0, :etilt_2100_upper => 10.0},
      'Mobi: MB3F-90-17DE' => {:bands => ['1800', '2100'], :etilt_900_upper => nil, :etilt_1800_upper => 10.0, :etilt_2100_upper => 10.0},
      'Mobi: MB3BH_3F-65-16_17DE' => {:bands => ['Dual_900_1800'], :etilt_900_upper => 10.0, :etilt_1800_upper => 8.0, :etilt_2100_upper => 8.0},
      'Mobi: MB3BH_3F-65-17_18DE' => {:bands => ['Dual_900_1800'], :etilt_900_upper => 10.0, :etilt_1800_upper => 8.0, :etilt_2100_upper => 8.0},
      'Mobi: MB3BH_3F-65-14_17DE' => {:bands => ['Dual_900_1800'], :etilt_900_upper => 14.0, :etilt_1800_upper => 10.0, :etilt_2100_upper => 10.0},
      'Mobi: MB7f-d7/9-wc-001' => {:bands => ['Dual_900_1800'], :etilt_900_upper => 0.0, :etilt_1800_upper => 0.0, :etilt_2100_upper => 0.0},
      'Mobi: MB3BH-65-15DE' => {:bands => ['900'], :etilt_900_upper => 14.0, :etilt_1800_upper => nil, :etilt_2100_upper => nil},
      'Mobi: MB3BH-65-18-DDE' => {:bands => ['900'], :etilt_900_upper => 12.0, :etilt_1800_upper => nil, :etilt_2100_upper => nil},
      'Mobi: MB3BH-65-18-DE' => {:bands => ['900'], :etilt_900_upper => 12.0, :etilt_1800_upper => nil, :etilt_2100_upper => nil},
      'Mobi: MB3BH-90-16.5DE10' => {:bands => ['900'], :etilt_900_upper => 10.0, :etilt_1800_upper => nil, :etilt_2100_upper => nil},
      'Huawei: ATR451704' => {:bands => ['Tri_900_1800_1800', 'Tri_900_1800_2100'], :etilt_900_upper => 9.0, :etilt_1800_upper => 10.0, :etilt_2100_upper => 10.0},
      'Huawei: ADU451802' => {:bands => ['Double_1800_1800', 'Double_1800_2100'], :etilt_900_upper => nil, :etilt_1800_upper => 10.0, :etilt_2100_upper => 10.0},
      'Huawei: ADU451900' => {:bands => ['Double_1800_1800', 'Double_1800_2100'], :etilt_900_upper => nil, :etilt_1800_upper => 8.0, :etilt_2100_upper => 8.0},
      'Indoor' => {:bands => ['Dual_900_1800', 'Dual_1800_2100'], :etilt_900_upper => 0.0, :etilt_1800_upper => 0.0, :etilt_2100_upper => 0.0},
    }

    unless (antenna_specs[code][:bands].include? band)
      errors.add(:base, "Error: Selected antenna supports bands: #{antenna_specs[code][:bands].join(',')}")
    end

    unless (electrical_tilt_900.nil?)
      if ( antenna_specs[code][:etilt_900_upper].nil? or electrical_tilt_900 < 0 or electrical_tilt_900 > antenna_specs[code][:etilt_900_upper] )
        errors.add(:base, "Error: Selected antenna's 900 tilt range is: 0-#{antenna_specs[code][:etilt_900_upper]||0.to_s}")
      end
    end

    unless (electrical_tilt_1800.nil?)
      if ( antenna_specs[code][:etilt_1800_upper].nil? or electrical_tilt_1800 < 0 or electrical_tilt_1800 > antenna_specs[code][:etilt_1800_upper] )
        errors.add(:base, "Error: Selected antenna's 1800 tilt range is: 0-#{antenna_specs[code][:etilt_1800_upper]||0.to_s}")
      end
    end

    unless (electrical_tilt_2100.nil?)
      if ( antenna_specs[code][:etilt_2100_upper].nil? or electrical_tilt_2100 < 0 or electrical_tilt_2100 > antenna_specs[code][:etilt_2100_upper] )
        errors.add(:base, "Error: Selected antenna's 2100 tilt range is: 0-#{antenna_specs[code][:etilt_2100_upper]||0.to_s}")
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

  def effective_tilt_2100
    if (mechanical_tilt || electrical_tilt_2100).nil?
      nil
    else
      mechanical_tilt.to_i + electrical_tilt_2100.to_i
    end
  end

  # Constants
  #BANDS = ["900", "1800", "2100", "Dual", "Tri"]
  BANDS = ["900", "1800", "2100", "Dual_900_1800", "Dual_1800_2100", "Double_1800_1800", "Double_1800_2100", "Tri_900_1800_1800", "Tri_900_1800_2100"]
  #BANDS = ["900", "1800", "Dual"]

  ANTENNA_TYPES = [ 'Andrew: DB874G35A-XY', 'Andrew: HBX-6516DS-VTM',
                    'Andrew: HBX-6517DS-VTM', 'Andrew: HBX-9014DS-VTM',
                    'Andrew: HBXX-6516DS-VTM',
                    'Andrew: HBXX-6517DS-VTM',
                    'Andrew: DBXLH-6565A-VTM', 'Andrew: DBXLH-6565B-VTM',
                    'Andrew: DBXLH-6565C-VTM',
                    'Andrew: LBX-3319DS-VTM',
                    'Andrew: LBX-6513DS-VTM',
                    'Andrew: LBX-6516DS-VTM', 'Andrew: LBX-9013DS-VTM',
                    'Andrew: LBXX-6516DS-VTM', 'Kathrein: 80010137',
                    'Kathrein: 741989', 'Kathrein: 742212',
                    'Kathrein: 742213',
                    'Kathrein: 742215', 'Kathrein: 742265',
                    'Kathrein: 742266', 'Kathrein: 80010248',
                    'Kathrein: 739665', 'Kathrein: 739684',
                    'Kathrein: 739686',
                    'Kathrein: K7345647',
                    'Mobi: MB6F-03 5-c-i-s',
                    'Mobi: MB3F-65-18DE10', 'Mobi: MB3F-65-20DE',
                    'Mobi: MB3F-90-17DE', 'Mobi: MB3BH_3F-65-16_17DE',
                    'Mobi: MB3BH_3F-65-17_18DE', 'Mobi: MB3BH_3F-65-14_17DE',
                    'Mobi: MB7f-d7/9-wc-001', 'Mobi: MB3BH-65-15DE',
                    'Mobi: MB3BH-65-18-DDE', 'Mobi: MB3BH-65-18-DE',
                    'Mobi: MB3BH-90-16.5DE10',
                    'Huawei: ATR451704', 'Huawei: ADU451802', 'Huawei: ADU451900',
                    'Indoor'
  ]


  #

end
