class DropSurveys < ActiveRecord::Migration
  def up
    drop_table :surveys
  end

  def down
  end
end
