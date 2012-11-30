class CreateProposals < ActiveRecord::Migration
  def change
    create_table :proposals do |t|
      t.decimal :hba
      t.decimal :azimuth
      t.decimal :mechanical_tilt
      t.decimal :electrical_tilt_900
      t.decimal :electrical_tilt_1800
      t.decimal :electrical_tilt_2100
      t.string :design_status
      t.integer :antenna_id

      t.timestamps
    end
  end
end
