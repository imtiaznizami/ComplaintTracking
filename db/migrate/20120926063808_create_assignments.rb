class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|

      t.references :role, :user
    end
  end
end
