class CreateSurveys < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
      t.string :name
      t.datetime :received_on
      t.datetime :closed_on
      t.string :sales_officer
      t.string :rf_engineer
      t.string :drive_tester
      t.string :log
      t.string :status
      t.string :rf_decision
      t.string :solution

      t.timestamps
    end
  end
end
