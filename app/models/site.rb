class Site < ActiveRecord::Base
  attr_accessible :code, :name, :equipment_vendor, :equipment_type, :type,
    :coverage_type, :cabinet_type, :structure_type, :structure_height,
    :building_height, :amsl, :phase, :on_air_date, :status,
    :address_attributes, :partner_attributes, :audit_attributes, :comments_attributes, :sectors_attributes,
    :created_at, :updated_at #, :id

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
end
