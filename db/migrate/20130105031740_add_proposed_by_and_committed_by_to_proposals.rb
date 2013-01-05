class AddProposedByAndCommittedByToProposals < ActiveRecord::Migration
  def change
    add_column :proposals, :proposed_by, :integer

    add_column :proposals, :committed_by, :integer

  end
end
