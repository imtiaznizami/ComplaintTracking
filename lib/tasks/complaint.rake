require 'csv'

namespace :complaints do

  desc "Add new complaints to database"
  task :add => :environment do
  
    count_added = 0
    count_updated = 0
    start_time = Time.now
    file_path = "#{Rails.root}/public/new_complaints/"
    file_name = "#{Time.now.strftime("%Y%m%d")}.csv"
  
    if FileTest.exists?("#{file_path}#{file_name}")
      puts "Importing #{file_path}#{file_name}"
  
      begin
        CSV.foreach("#{file_path}#{file_name}",
                    :col_sep => ",",
                    :headers => :true,
                    :header_converters => :symbol,
                    :skip_blanks => :true) do |line|
  
          print "."
  
          if !Complaint.where(:incident => line[:number]).first()
            Complaint.new do |c|
              count_added = count_added + 1
              c.incident = line[:number] == nil ? nil : line[:number].to_s
              c.assigned_to = line[:assign_to] == nil ? nil : line[:assign_to].to_s
              c.noc_status = line[:problem_status] == nil ? nil : line[:problem_status].to_s
  
              if (line[:escalation_time] != nil)
                date = line[:escalation_time].split(" ")[0].split("/").reverse.join("-")
                c.escalation_time = date + " " + line[:escalation_time].split(" ")[1]
              end
  
              c.msisdn = line[:msisdn] == nil ? nil : line[:msisdn].to_s
              c.party_a = line[:party_a] == nil ? nil : line[:party_a].to_s
              c.ne_name = line[:ne_name] == nil ? nil : line[:ne_name].to_s
              c.cell_id = line[:cell_id] == nil ? nil : line[:cell_id].to_s
              c.brief_description = line[:brief_description] == nil ? nil : line[:brief_description].to_s
              c.revenue_band = line[:revenue_band] == nil ? nil : line[:revenue_band].to_s
              c.package_type = line[:package_type] == nil ? nil : line[:package_type].to_s
              c.duration = line[:duration] == nil ? nil : line[:duration].to_s
              c.save!
            end
          else
            count_updated = count_updated + 1
            c = Complaint.where(:incident => line[:number]).first()
            c.assigned_to = line[:assign_to] == nil ? nil : line[:assign_to].to_s
            c.noc_status =  line[:problem_status] == nil ? nil : line[:problem_status].to_s
  
            if (line[:escalation_time] != nil)
              date = line[:escalation_time].split(" ")[0].split("/").reverse.join("-")
              c.escalation_time = date + " " + line[:escalation_time].split(" ")[1]
            end
  
            c.msisdn = line[:msisdn] == nil ? nil : line[:msisdn].to_s
            c.party_a = line[:party_a] == nil ? nil : line[:party_a].to_s
            c.ne_name = line[:ne_name] == nil ? nil : line[:ne_name].to_s
            c.cell_id = line[:cell_id] == nil ? nil : line[:cell_id].to_s
            c.brief_description = line[:brief_description] == nil ? nil : line[:brief_description].to_s
            c.revenue_band = line[:revenue_band] == nil ? nil : line[:revenue_band].to_s
            c.package_type = line[:package_type] == nil ? nil : line[:package_type].to_s
            c.duration = line[:duration] == nil ? nil : line[:duration].to_s
            c.save!
          end
  
        end
      rescue CSV::MalformedCSVError #rescue the error to more gracefully display the info
        puts "Rescued!"    
        exit
      end
    end
  
    puts "#{count_added} complaints added / #{count_updated} complaints updated."
    puts start_time.strftime("%d/%m/%Y %H:%M:%S")
    puts Time.now.strftime("%d/%m/%Y %H:%M:%S")
  end
  
  desc "update complaints already in database"
  task :update => :environment do
  
    count_updated = 0
    start_time = Time.now
    file_path = "#{Rails.root}/public/new_complaints/"
    file_name = "#{Time.now.strftime("%Y%m%d")}_updates.csv"
  
    if FileTest.exists?("#{file_path}#{file_name}")
      puts "Importing #{file_path}#{file_name}"
  
      begin
        CSV.foreach("#{file_path}#{file_name}",
                    :col_sep => ",",
                    :headers => :true,
                    :header_converters => :symbol,
                    :skip_blanks => :true) do |line|
  
          print "."
  
          if Complaint.where(:incident => line[:number]).first()
            count_updated = count_updated + 1
            c = Complaint.where(:incident => line[:number]).first()
            c.package_type = line[:package_type]
            c.save!
          end
  
        end
      rescue CSV::IllegalFormatError #rescue the error to more gracefully display the info
        puts "Rescued!"    
        exit
      end
    end
  
    puts "#{count_updated} complaints updated."
    puts start_time.strftime("%d/%m/%Y %H:%M:%S")
    puts Time.now.strftime("%d/%m/%Y %H:%M:%S")
  end

  desc "Put all complaints in state: Completed"
  task :close_all => :environment do
    Complaint.update_all :noc_status => 'Completed'
  end
  

end 
