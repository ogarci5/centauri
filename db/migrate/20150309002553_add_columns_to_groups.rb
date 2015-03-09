class AddColumnsToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :filter, :boolean
    add_reference :groups, :group, index: true
    add_foreign_key :groups, :groups
    add_column :groups, :visible, :boolean
  end
end
