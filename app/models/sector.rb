class Sector < ActiveRecord::Base
  attr_accessible :code, :cell, :serving_area, :morphology, :bracket_type,
    :feeder_type, :feeder_length, :blocking, :site_id, :created_at, :updated_at, :id,
    :antennas_attributes, :proposals_attributes, :comments_attributes,
    :azimuth, :antenna_900, :antenna_1800, :antenna_2100, :physical_sector_count

  # To incorporate full text searches
  include PgSearch
  pg_search_scope :search_by_vitals, :against => {
    :code => 'A',
    :cell => 'B',
    :serving_area => 'C',
    :morphology => 'D'
  },
  :using => {:tsearch => {:prefix => true}}

  # Validations
  validates_presence_of :code
  # Commented out to cater for imports where site is to be created along with sector
  #validates_presence_of :site_id
  validates_uniqueness_of :code, :message => "Sector code has already been taken."
  validates_numericality_of :cell, :only_integer => true, :allow_nil => true

  validate :correct_azimuth

  # Relations
  belongs_to :site
  has_many :antennas, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :proposals, :through => :antennas
  #has_paper_trail :ignore => [:updated_at, :created_at]

  accepts_nested_attributes_for :antennas, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :comments, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true

  def redesigns
    
  end

  def correct_azimuth
    a = self.antennas.first.azimuth

    self.antennas.each do |antenna|
      if a != antenna.azimuth
        errors.add(:base, "Error: We cannot have antennas with multiple azimuths per sector.")
      end
    end
  end

  # TODO: Improve implementation
  def azimuth
###    azimuth_hash = Hash.new
###    antennas.each do |a|
###      azimuth_hash[a.band] = a.azimuth
###    end
###    azimuth_hash["Dual"] || azimuth_hash["900"] || azimuth_hash["1800"]

    az = nil
    antennas.each do |a|
      az = az || a.azimuth
    end
    az
  end

  def antenna_900
    antennas.where("band like ?", "%900%").first || Antenna.new
  end

  def antenna_1800
    antennas.where("band like ?", "%1800%").first || Antenna.new
  end

  def antenna_2100
    antennas.where("band like ?", "%2100%").first || Antenna.new
  end
end
