class AddJoinTableGroupResources < ActiveRecord::Migration
  def change
    create_join_table :groups, :resources do |t|
      t.index [:group_id, :resource_id]
      # t.index [:resource_id, :group_id]
    end
  end
end
