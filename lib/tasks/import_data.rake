require 'csv'
require 'fileutils'

namespace :import do

desc "Add/update proposals"
task :proposals => :environment do

count_added_updated = 0
arr = Array.new
start_time = Time.now
file_path = "#{Rails.root}/db/"
file_name = "proposals.csv"

if FileTest.exists?("#{file_path}#{file_name}")
	puts "Importing #{file_path}#{file_name}"

	CSV.foreach("#{file_path}#{file_name}", headers: true) do |row|
		print "." if count_added_updated % 100 == 0
		count_added_updated = count_added_updated + 1
		p = Proposal.find_by_id( row[:id] ) || Proposal.new
		p.attributes = row.to_hash.slice(*Proposal.accessible_attributes)
		arr.push(p)
	end

	if arr.map(&:valid?).all?
		arr.each(&:save!)
		true
	else
		arr.each_with_index do |proposal, index|
			proposal.errors.full_messages.each do |message|
				puts "Row #{index+2}: #{message}"
			end
		end
		false
	end

end

puts "\n#{count_added_updated} proposals added / updated."
puts start_time.strftime("%d/%m/%Y %H:%M:%S")
puts Time.now.strftime("%d/%m/%Y %H:%M:%S")
end

# ------------------------------
desc "Add/update addresses"
task :addresses => :environment do

count_added_updated = 0
arr = Array.new
start_time = Time.now
file_path = "#{Rails.root}/db/"
file_name = "addresses.csv"

if FileTest.exists?("#{file_path}#{file_name}")
	puts "Importing #{file_path}#{file_name}"

	CSV.foreach("#{file_path}#{file_name}", headers: true) do |row|
		print "." if count_added_updated % 100 == 0
		count_added_updated = count_added_updated + 1

		a = Address.where( :site_id => row["site_id"] ).first || Address.new
		#a.attributes = row.to_hash.slice(*Address.accessible_attributes)

		a.city = row["city"].encode("UTF-8") unless row["city"].nil?
		a.area_name = row["area_name"].encode("UTF-8") unless row["area_name"].nil?
		a.line = row["line"].encode("UTF-8") unless row["line"].nil?
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
desc "Update sites"
task :sites => :environment do

count_updated = 0
arr = Array.new
start_time = Time.now
file_path = "#{Rails.root}/db/"
file_name = "site.csv"

if FileTest.exists?("#{file_path}#{file_name}")
	puts "Importing #{file_path}#{file_name}"

	CSV.foreach("#{file_path}#{file_name}", headers: true) do |row|
		print "." if count_updated % 100 == 0
		count_updated = count_updated + 1

		s = Site.where( :id => row["id"] ).first
		s.attributes = row.to_hash.slice(*Site.accessible_attributes)
		arr.push(s)
	end

	if arr.map(&:valid?).all?
		arr.each(&:save!)
		true
	else
		arr.each_with_index do |site, index|
			site.errors.full_messages.each do |message|
				puts "Row #{index+2}: #{message}"
			end
		end
		false
	end

end

puts "\n#{count_updated} sites updated."
puts start_time.strftime("%d/%m/%Y %H:%M:%S")
puts Time.now.strftime("%d/%m/%Y %H:%M:%S")
end


# ------------------------------
desc "Update partners"
task :partners => :environment do

count_updated = 0
arr = Array.new
start_time = Time.now
file_path = "#{Rails.root}/db/"
file_name = "partner.csv"

if FileTest.exists?("#{file_path}#{file_name}")
	puts "Importing #{file_path}#{file_name}"

	CSV.foreach("#{file_path}#{file_name}", headers: true) do |row|
		print "." if count_updated % 100 == 0
		count_updated = count_updated + 1

		p = Partner.where( :id => row["id"] ).first
		p.attributes = row.to_hash.slice(*Partner.accessible_attributes)
		arr.push(p)
	end

	if arr.map(&:valid?).all?
		arr.each(&:save!)
		true
	else
		arr.each_with_index do |partner, index|
			partner.errors.full_messages.each do |message|
				puts "Row #{index+2}: #{message}"
			end
		end
		false
	end

end

puts "\n#{count_updated} partners updated."
puts start_time.strftime("%d/%m/%Y %H:%M:%S")
puts Time.now.strftime("%d/%m/%Y %H:%M:%S")
end


end 
