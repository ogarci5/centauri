class AddRankToGroupsResources < ActiveRecord::Migration
  def change
    add_column :groups_resources, :rank, :integer, null: false, default: 0
    add_column :groups_resources, :id, :primary_key
    add_column :groups_resources, :created_at, :datetime, null: false
    add_column :groups_resources, :updated_at, :datetime, null: false
  end
end
