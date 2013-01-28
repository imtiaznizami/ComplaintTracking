require 'csv'
require 'fileutils'

namespace :data do
namespace :export do

desc "Export site database"
task :database => :environment do

count = 0
start_time = Time.now
file_path = "#{Rails.root}/tmp/"
file_name = "site_database.csv"
file = "#{file_path}#{file_name}"

File.delete(file) if FileTest.exists?(file)

site_data = Site.first.attributes.keys.reject {|elt| ["id", "created_at", "updated_at"].include?(elt)}
sector_data = Sector.first.attributes.keys.reject {|elt| ["id", "created_at", "updated_at", "site_id"].include?(elt)}
antenna_data = Antenna.first.attributes.keys.reject {|elt| ["created_at", "updated_at", "sector_id", "electrical_tilt_2100"].include?(elt)}

CSV.open(file, "wb") do |csv|
  csv << [
    site_data.map {|elt| "site:" + elt},
    sector_data.map {|elt| "sector:" + elt},
    antenna_data.map {|elt| "antenna:" + elt}
  ].flatten
  Site.all.each do |site|
    site.sectors.each do |sector|
      sector.antennas.each do |antenna|
        csv << [
          site.attributes.values_at(*site_data),
          sector.attributes.values_at(*sector_data),
          antenna.attributes.values_at(*antenna_data)
        ].flatten
      end
    end
  end
end

puts "\n#{count} records exported."
puts start_time.strftime("%d/%m/%Y %H:%M:%S")
puts Time.now.strftime("%d/%m/%Y %H:%M:%S")

end 
end 
end
