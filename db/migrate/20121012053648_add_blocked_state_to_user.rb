class AddBlockedStateToUser < ActiveRecord::Migration
  def change
    add_column :users, :blocked, :boolean

  end
end
