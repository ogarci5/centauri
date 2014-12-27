class Resource < ActiveRecord::Base
  has_attached_file :file
  has_and_belongs_to_many :groups
end
