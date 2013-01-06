class AddProposedAndCommittedFieldsToProposals < ActiveRecord::Migration
  def change
    add_column :proposals, :proposed_by, :integer

    add_column :proposals, :proposed_at, :datetime

    add_column :proposals, :committed_by, :integer

    add_column :proposals, :committed_at, :datetime

  end
end
