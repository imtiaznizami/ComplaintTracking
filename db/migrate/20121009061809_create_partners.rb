class CreatePartners < ActiveRecord::Migration
  def change
    create_table :partners do |t|
      t.string :status
      t.string :operator
      t.string :code
      t.integer :site_id

      t.timestamps
    end
  end
end
