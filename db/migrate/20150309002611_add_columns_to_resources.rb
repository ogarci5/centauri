class AddColumnsToResources < ActiveRecord::Migration
  def change
    add_column :resources, :order, :integer
  end
end
