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
      imported_sites.each(&:save!)
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
      site = Site.find_by_id(row["id"]) || Site.new
      site.build_address if site.address.nil?
      site.build_partner if site.partner.nil?
      site.build_audit if site.audit.nil?

      site.attributes = row.to_hash.slice(*Site.accessible_attributes)


###      #site.partner.attributes = row.to_hash.slice(*Address.accessible_attributes)
###      site.address.attributes = row.to_hash.dup.inject({}) do |result, (k, v)|
###        result[k.gsub(/^address_/,'')] = v if k.start_with?('address_')
###        result
###      end
###
###      #site.partner.attributes = row.to_hash.slice(*Partner.accessible_attributes)
###      site.partner.attributes = row.to_hash.dup.inject({}) do |result, (k, v)|
###        result[k.gsub(/^partner_/,'')] = v if k.start_with?('partner_')
###        result
###      end
###
###      #site.audit.attributes = row.to_hash.slice(*Audit.accessible_attributes)
###      site.address.attributes = row.to_hash.dup.inject({}) do |result, (k, v)|
###        result[k.gsub(/^audit_/,'')] = v if k.start_with?('audit_')
###        result
###      end

      arr.push(site)
    end
    arr
  end


end
