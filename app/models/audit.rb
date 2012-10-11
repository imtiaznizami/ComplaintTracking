class Audit < ActiveRecord::Base
  belongs_to :site
  #has_paper_trail :ignore => [:updated_at, :created_at]
end
