class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.strin :name
      t.boolean :main

      t.timestamps null: false
    end
  end
end
