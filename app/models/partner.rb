class Partner < ActiveRecord::Base
  attr_accessible :status, :operator, :code

  belongs_to :site
  #has_paper_trail :ignore => [:updated_at, :created_at]
end
