class Audit < ActiveRecord::Base
  attr_accessible :date, :rigger, :status

  belongs_to :site
  #has_paper_trail :ignore => [:updated_at, :created_at]
end
