require 'csv'
require 'fileutils'

namespace :data do
namespace :export do

desc "Export site database"
task :backup do
file_path = "/media/sf_vbox02/"
file_name = "ap_#{Time.now.strftime("%Y%m%d")}.dump"
file = "#{file_path}#{file_name}"

i = 0
while FileTest.exists?(file) do
  i += 1
  file = "#{file_path}#{file_name}#{i}"
end

sh "pg_dump avion_production > #{file}"
end

desc "Export site database"
task :completeDB => :environment do

if Rails.env.development? then
  raise "Error: You are in development environment."
end

count = 0
start_time = Time.now
file_path = "#{Rails.root}/public/exports/"
file_name = "completeDB.csv"
file = "#{file_path}#{file_name}"

File.delete(file) if FileTest.exists?(file)

site_data = Site.first.attributes.keys.reject {|elt| ["id", "created_at", "updated_at"].include?(elt)}
sector_data = Sector.first.attributes.keys.reject {|elt| ["id", "created_at", "updated_at", "site_id"].include?(elt)}
antenna_data = Antenna.first.attributes.keys.reject {|elt| ["created_at", "updated_at", "sector_id", "electrical_tilt_2100"].include?(elt)}
address_data = Address.first.attributes.keys.reject {|elt| ["id", "created_at", "updated_at", "sector_id"].include?(elt)}
partner_data = Partner.first.attributes.keys.reject {|elt| ["id", "created_at", "updated_at", "sector_id"].include?(elt)}
audit_data = Audit.first.attributes.keys.reject {|elt| ["id", "created_at", "updated_at", "sector_id"].include?(elt)}

CSV.open(file, "wb") do |csv|
  csv << [
    site_data.map {|elt| "site:" + elt},
    sector_data.map {|elt| "sector:" + elt},
    antenna_data.map {|elt| "antenna:" + elt},
    address_data.map {|elt| "address:" + elt},
    partner_data.map {|elt| "partner:" + elt},
    audit_data.map {|elt| "audit:" + elt},
  ].flatten
  Site.all.each do |site|
    site.sectors.each do |sector|
      sector.antennas.each do |antenna|
        csv << [
          site.attributes.values_at(*site_data),
          sector.attributes.values_at(*sector_data),
          antenna.attributes.values_at(*antenna_data),
          site.address.attributes.values_at(*address_data),
          site.partner.attributes.values_at(*partner_data),
          site.audit.attributes.values_at(*audit_data),
        ].flatten
      end
    end
  end
end

puts "\n#{count} records exported."
puts start_time.strftime("%d/%m/%Y %H:%M:%S")
puts Time.now.strftime("%d/%m/%Y %H:%M:%S")

end 

desc "Export site database"
task :shortDB => :environment do

if Rails.env.development? then
  raise "Error: You are in development environment."
end

count = 0
start_time = Time.now
file_path = "#{Rails.root}/public/exports/"
file_name = "shortDB.csv"
file = "#{file_path}#{file_name}"

File.delete(file) if FileTest.exists?(file)

#CSV.generate do |csv|
CSV.open(file, "wb") do |csv|
  csv << %w(
          code:site
          code:sector
          site_name
          cell
          latitude
          longitude
          azimuth:sector
          code:900:antenna
          band:900:antenna
          hba:900:antenna
          azimuth:900:antenna
          mechanical:900:tilt:antenna
          electrical:900:tilt:antenna
          effective:900:tilt:antenna
          code:1800:antenna
          band:1800:antenna
          hba:1800:antenna
          azimuth:1800:antenna
          mechanical:1800:tilt:antenna
          electrical:1800:tilt:antenna
          effective:1800:tilt:antenna
          code:2100:antenna
          band:2100:antenna
          hba:2100:antenna
          azimuth:2100:antenna
          mechanical:2100:tilt:antenna
          electrical:2100:tilt:antenna
          effective:2100:tilt:antenna
          sector_count:site
          antenna_count:sector
          blocking:sector
          bracket_type:sector
          phase
          building_height
          amsl
          structure_type
          structure_height
          coverage_type
          cabinet_type
          address:line
          address:area_name
          address:city
          address:district
          address:province
          partner:code
          partner:operator
          partner:status
  )
  Site.all.each do |site|
    #where(:code => "KHD507").each do |site|
    site.sectors.each do |sector|
      csv << [
        site.code,
        sector.code,
        site.name,
        sector.cell,
        site.address.latitude,
        site.address.longitude,
        sector.azimuth,
        sector.antenna_900.code,
        sector.antenna_900.band,
        sector.antenna_900.hba,
        sector.antenna_900.azimuth,
        sector.antenna_900.mechanical_tilt,
        sector.antenna_900.electrical_tilt_900,
        sector.antenna_900.effective_tilt_900,
        sector.antenna_1800.code,
        sector.antenna_1800.band,
        sector.antenna_1800.hba,
        sector.antenna_1800.azimuth,
        sector.antenna_1800.mechanical_tilt,
        sector.antenna_1800.electrical_tilt_1800,
        sector.antenna_1800.effective_tilt_1800,
        sector.antenna_2100.code,
        sector.antenna_2100.band,
        sector.antenna_2100.hba,
        sector.antenna_2100.azimuth,
        sector.antenna_2100.mechanical_tilt,
        sector.antenna_2100.electrical_tilt_2100,
        sector.antenna_2100.effective_tilt_2100,
        site.physical_sector_count,
        sector.antennas.count,
        sector.blocking,
        sector.bracket_type,
        site.phase,
        site.building_height,
        site.amsl,
        site.structure_type,
        site.structure_height,
        site.coverage_type,
        site.cabinet_type,
        site.address.line,
        site.address.area_name,
        site.address.city,
        site.address.district,
        site.address.province,
        site.partner.code,
        site.partner.operator,
        site.partner.status,
      ]
    end
      end
  end

  puts "\n#{count} records exported."
  puts start_time.strftime("%d/%m/%Y %H:%M:%S")
  puts Time.now.strftime("%d/%m/%Y %H:%M:%S")
end

desc "Export database; regenerate complete and short databases"
task :all => [:backup, :completeDB, :shortDB]

end 
end
