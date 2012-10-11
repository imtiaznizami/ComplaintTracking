class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.decimal :latitude
      t.decimal :longitude
      t.string :line
      t.string :area_name
      t.string :postal_code
      t.string :city
      t.string :union_council
      t.string :tehsil
      t.string :district
      t.string :province
      t.string :region
      t.integer :site_id

      t.timestamps
    end
  end
end
