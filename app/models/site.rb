class Site < ActiveRecord::Base
  attr_accessible :code, :name, :equipment_vendor, :equipment_type, :type,
    :coverage_type, :cabinet_type, :structure_type, :structure_height,
    :building_height, :amsl, :phase, :on_air_date, :status,
    :address_attributes, :partner_attributes, :audit_attributes, :comments_attributes, :sectors_attributes,
    :created_at, :updated_at #, :id

  # To incorporate full text searches
  include PgSearch
  pg_search_scope :search_by_vitals, :against => {
    :code => 'A',
    :coverage_type => 'B',
    :cabinet_type => 'C',
    :equipment_vendor => 'D'
  },
  :using => {:tsearch => {:prefix => true}}


  # Validations
  validates_presence_of :code
  validates_uniqueness_of :code
  validates_numericality_of :building_height, :allow_nil => true
  validates_numericality_of :amsl, :allow_nil => true

  # Relations
  has_one :address, :dependent => :destroy
  has_one :partner, :dependent => :destroy
  has_one :audit, :dependent => :destroy
  has_many :sectors, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy
  #has_paper_trail :ignore => [:updated_at, :created_at]

  accepts_nested_attributes_for :address, :allow_destroy => true
  accepts_nested_attributes_for :partner, :allow_destroy => true
  accepts_nested_attributes_for :audit, :allow_destroy => true
  accepts_nested_attributes_for :sectors, :allow_destroy => true
  accepts_nested_attributes_for :comments, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true

  def self.to_csv
    file_path = "#{Rails.root}/tmp/"
    file_name = "site_database_long.csv"
    file = "#{file_path}#{file_name}"

    site_data = Site.first.attributes.keys.reject {|elt| ["id", "created_at", "updated_at"].include?(elt)}
    sector_data = Sector.first.attributes.keys.reject {|elt| ["id", "created_at", "updated_at", "site_id"].include?(elt)}
    antenna_data = Antenna.first.attributes.keys.reject {|elt| ["created_at", "updated_at", "sector_id", "electrical_tilt_2100"].include?(elt)}

    unless FileTest.exists?(file)
      #CSV.generate do |csv|
      CSV.open(file, "wb") do |csv|
        csv << [
          site_data.map {|elt| "site:" + elt},
          sector_data.map {|elt| "sector:" + elt},
          antenna_data.map {|elt| "antenna:" + elt}
        ].flatten
        all.each do |site|
          #where(:code => "KHD507").each do |site|
          site.sectors.each do |sector|
            sector.antennas.each do |antenna|
              csv << [
                site.attributes.values_at(*site_data),
                sector.attributes.values_at(*sector_data),
                antenna.attributes.values_at(*antenna_data)
              ].flatten
            end
          end
        end
      end
    end

    CSV.generate do |csv|
      CSV.foreach(file) do |row|
        csv << row
      end
    end

  end

end
