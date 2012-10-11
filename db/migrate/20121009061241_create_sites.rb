class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :code
      t.string :name
      t.string :equipment_vendor
      t.string :equipment_type
      t.string :type
      t.string :coverage_type
      t.string :cabinet_type
      t.string :structure_type
      t.decimal :structure_height
      t.decimal :building_height
      t.decimal :amsl
      t.string :phase
      t.datetime :on_air_date
      t.string :status

      t.timestamps
    end
  end
end
