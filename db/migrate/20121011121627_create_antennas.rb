class CreateAntennas < ActiveRecord::Migration
  def change
    create_table :antennas do |t|
      t.string :band
      t.string :vendor
      t.string :code
      t.decimal :hba
      t.decimal :azimuth
      t.decimal :mechanical_tilt
      t.decimal :electrical_tilt_900
      t.decimal :electrical_tilt_1800
      t.decimal :electrical_tilt_2100
      t.string :design_status
      t.integer :sector_id

      t.timestamps
    end
  end
end
