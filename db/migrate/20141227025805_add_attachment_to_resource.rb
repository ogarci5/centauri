class AddAttachmentToResource < ActiveRecord::Migration
  def self.up
    add_attachment :resources, :file
  end
  def self.down
    remove_attachment :resources, :file
  end
end
