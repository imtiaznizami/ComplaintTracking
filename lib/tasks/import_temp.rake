require 'csv'
require 'fileutils'

namespace :import_temp do

# ------------------------------
desc "Add/update addresses"
task :addresses_temp => :environment do

count_added_updated = 0
arr = Array.new
start_time = Time.now
file_path = "#{Rails.root}/db/"
file_name = "address.csv"

if FileTest.exists?("#{file_path}#{file_name}")
	puts "Importing #{file_path}#{file_name}"

	CSV.foreach("#{file_path}#{file_name}", headers: true) do |row|
		print "." if count_added_updated % 100 == 0
		count_added_updated = count_added_updated + 1

		a = Address.where( :site_id => row["site_id"] ).first || Address.new

		a.region = row["region"].encode("UTF-8") unless row["region"].nil?
		a.line = row["line"].encode("UTF-8") unless row["line"].nil?
		a.city = row["city"].encode("UTF-8") unless row["city"].nil?
		a.area_name = row["area_name"].encode("UTF-8") unless row["area_name"].nil?
		a.latitude = row["latitude"].encode("UTF-8") unless row["latitude"].nil?
		a.longitude = row["longitude"].encode("UTF-8") unless row["longitude"].nil?
		arr.push(a)
	end

	if arr.map(&:valid?).all?
		arr.each(&:save!)
		true
	else
		arr.each_with_index do |address, index|
			address.errors.full_messages.each do |message|
				puts "Row #{index+2}: #{message}"
			end
		end
		false
	end

end

puts "\n#{count_added_updated} addresses added / updated."
puts start_time.strftime("%d/%m/%Y %H:%M:%S")
puts Time.now.strftime("%d/%m/%Y %H:%M:%S")
end


# ------------------------------

end 
