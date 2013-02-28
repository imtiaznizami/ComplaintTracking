class Survey < ActiveRecord::Base
  attr_accessible :name, :received_on, :closed_on, :sales_officer,
      :rf_engineer, :drive_tester, :log, :status, :rf_decision,
      :solution, :comments_attributes

  # To incorporate full text searches
  include PgSearch
  pg_search_scope :search_by_vitals, :against => [
      :name,
      :sales_officer,
      :rf_engineer,
      :drive_tester,
      :log,
      :status,
      :rf_decision,
      :solution
  ],
  :using => {:tsearch => {:prefix => true}}

  # Relations
  has_many :comments, :as => :commentable, :dependent => :destroy

  accepts_nested_attributes_for :comments, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true
end
