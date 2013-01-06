class Sector < ActiveRecord::Base
  attr_accessible :code, :cell, :serving_area, :morphology, :bracket_type,
    :feeder_type, :feeder_length, :blocking, :site_id,
    :antennas_attributes, :comments_attributes

  # Validations
  validates_presence_of :code
  validates_presence_of :site_id
  validates_uniqueness_of :code

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
end
