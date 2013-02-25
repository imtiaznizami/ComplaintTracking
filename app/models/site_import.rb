class SiteImport
  # switch to ActiveModel::Model in Rails 4
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :file

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def persisted?
    false
  end

  def save
    if imported_sites.map(&:valid?).all?
      #imported_sites.each(&:save!)
      imported_sites.each do |s|
        puts s.code
        s.save!
      end
      true
    else
      imported_sites.each_with_index do |site, index|
        site.errors.full_messages.each do |message|
          errors.add :base, "Row #{index+2}: #{message}"
        end
      end
      false
    end
  end

  def imported_sites
    @imported_sites ||= load_imported_sites
  end

  #TODO: improvement in implementaion, in particular the making of "arr" array
  def load_imported_sites
    arr = Array.new
    CSV.foreach(file.path, headers: true) do |row|
      site = Site.find_by_code(row["code"]) || Site.new

      site.build_address if site.address.nil?
      site.build_partner if site.partner.nil?
      site.build_audit if site.audit.nil?

      site.attributes = row.to_hash.slice(*Site.accessible_attributes)

      site.address.attributes = row.to_hash.dup.inject({}) do |result, (k, v)|
        result[k.gsub(/^address_/,'')] = v if k.start_with?('address_')
        result
      end

      site.partner.attributes = row.to_hash.dup.inject({}) do |result, (k, v)|
        result[k.gsub(/^partner_/,'')] = v if k.start_with?('partner_')
        result
      end

      site.audit.attributes = row.to_hash.dup.inject({}) do |result, (k, v)|
        result[k.gsub(/^audit_/,'')] = v if k.start_with?('audit_')
        result
      end

      sector_attributes = row.to_hash.dup.inject({site_id: site.id}) do |result, (k, v)|
        result[k.gsub(/^sector_/,'')] = v if k.start_with?('sector_')
        result
      end

      s = site.sectors.where("site_id = ? AND code = ?", site.id, sector_attributes["code"]).first
      if s.nil?
        s = site.sectors.build(sector_attributes)
      else
        s.attributes = sector_attributes
      end

      antenna_attributes = row.to_hash.dup.inject({sector_id: s.id}) do |result, (k, v)|
        result[k.gsub(/^antenna_/,'')] = v if k.start_with?('antenna_')
        result
      end

      a = s.antennas.where("sector_id = ? AND id = ?", s.id, antenna_attributes["id"]).first
      if a.nil?
        s.antennas.build(antenna_attributes)
      else
        a.attributes = antenna_attributes
      end


      arr.push(site)
    end
    arr
  end


end
