class Site < ActiveRecord::Base
  attr_accessible :code, :name, :equipment_vendor, :equipment_type, :type,
    :coverage_type, :cabinet_type, :structure_type, :structure_height,
    :building_height, :amsl, :phase, :on_air_date, :status,
    :address_attributes, :partner_attributes, :audit_attributes

  has_one :address, :dependent => :destroy
  has_one :partner, :dependent => :destroy
  has_one :audit, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy
  #has_paper_trail :ignore => [:updated_at, :created_at]

  accepts_nested_attributes_for :address, :allow_destroy => true
  accepts_nested_attributes_for :partner, :allow_destroy => true
  accepts_nested_attributes_for :audit, :allow_destroy => true
  accepts_nested_attributes_for :comments, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true
end
