class CreateAudits < ActiveRecord::Migration
  def change
    create_table :audits do |t|
      t.datetime :date
      t.integer :user_id
      t.string :rigger
      t.string :status
      t.integer :site_id

      t.timestamps
    end
  end
end
