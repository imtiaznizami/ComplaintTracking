class Partner < ActiveRecord::Base
  attr_accessible :partner_status, :operator, :partner_code

  belongs_to :site
  #has_paper_trail :ignore => [:updated_at, :created_at]

  # Getter
  def partner_status
    status
  end

  # Setter
  def partner_status=(status)
    self.status = status
  end

  # Getter
  def partner_code
    status
  end

  # Setter
  def partner_code(code)
    self.code = code
  end

end
