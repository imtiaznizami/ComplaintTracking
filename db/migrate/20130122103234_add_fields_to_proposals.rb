class AddFieldsToProposals < ActiveRecord::Migration
  def change
    add_column :proposals, :proposed_by, :integer

    add_column :proposals, :proposed_at, :datetime

    add_column :proposals, :committed_by, :integer

    add_column :proposals, :committed_at, :datetime

    add_column :proposals, :code, :string

    add_column :proposals, :band, :string

  end
end
