class Site < ActiveRecord::Base
  attr_accessible :code, :name, :equipment_vendor, :equipment_type, :type,
    :coverage_type, :cabinet_type, :structure_type, :structure_height,
    :building_height, :amsl, :phase, :on_air_date, :status,
    :address_attributes, :partner_attributes, :audit_attributes, :comments_attributes

  # Validations
  validates_presence_of :code
  validates_uniqueness_of :code

  # Relations
  has_one :address, :dependent => :destroy
  has_one :partner, :dependent => :destroy
  has_one :audit, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy
  #has_paper_trail :ignore => [:updated_at, :created_at]

  accepts_nested_attributes_for :address, :allow_destroy => true
  accepts_nested_attributes_for :partner, :allow_destroy => true
  accepts_nested_attributes_for :audit, :allow_destroy => true
  accepts_nested_attributes_for :comments, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true


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



end
