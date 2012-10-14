class CreateSectors < ActiveRecord::Migration
  def change
    create_table :sectors do |t|
      t.string :code
      t.integer :cell
      t.string :serving_area
      t.string :morphology
      t.string :bracket_type
      t.string :feeder_type
      t.decimal :feeder_length
      t.string :blocking
      t.integer :site_id

      t.timestamps
    end
  end
end
