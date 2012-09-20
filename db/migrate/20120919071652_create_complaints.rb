class CreateComplaints < ActiveRecord::Migration
  def change
    create_table :complaints do |t|
      t.string :incident
      t.string :problem_status
      t.datetime :escalation_time
      t.string :msisdn
      t.string :party_a
      t.string :alternate_number
      t.string :ne_name
      t.string :cell_id
      t.string :brief_description
      t.string :revenue_band
      t.string :package_type
      t.string :duration
      t.string :noc_status
      t.string :assigned_to
      t.string :dt_conducted_by
      t.string :orf_sent_to

      t.timestamps
    end
  end
end
