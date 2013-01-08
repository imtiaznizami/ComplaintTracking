class Address < ActiveRecord::Base
  attr_accessible :latitude, :longitude, :line, :area_name,
    :postal_code, :city, :union_council, :tehsil, :district,
    :province, :region


  validates_numericality_of :latitude, :allow_nil => true
  validates_numericality_of :longitude, :allow_nil => true

  validates_numericality_of :latitude, :allow_nil => true

  belongs_to :site
  #has_paper_trail :ignore => [:updated_at, :created_at]
end
