class AddCodeToproposals < ActiveRecord::Migration
  def up
    add_column :proposals, :code, :string
  end

end
