class Complaint < ActiveRecord::Base
  has_many :comments, :as => :commentable, :dependent => :destroy
  accepts_nested_attributes_for :comments, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true

  def complaints_with_matching_telephone
    phone_numbers = [self.msisdn, self.alternate_number, self.party_a].collect {|tel| tel.to_s.gsub(/[^0-9]/,'') }.delete_if {|tel| '' == tel }
    self.class.find(:all, :conditions => ["id <> ? and (msisdn in (?) or alternate_number in (?) or party_a in (?))", self.id, phone_numbers, phone_numbers, phone_numbers])
  end

  # Updates all numbers in database with standard format
  def tel_updates
    Complaint.all.each do |c|
      c.msisdn = c.msisdn.to_s.gsub(/[^0-9]/,'') == '' ? nil : c.msisdn.to_s.gsub(/[^0-9]/,'')
      c.alternate_number = c.alternate_number.to_s.gsub(/[^0-9]/,'') == '' ? nil : c.alternate_number.to_s.gsub(/[^0-9]/,'')
      c.party_a = c.party_a.to_s.gsub(/[^0-9]/,'') == '' ? nil : c.party_a.to_s.gsub(/[^0-9]/,'')
      c.save!
      print "."
    end
    puts "end"
  end
  
  def self.total_on(date)
    Complaint.count(:conditions => ["escalation_time >= ? and escalation_time < ? ", date, date+1])
  end
	
end
