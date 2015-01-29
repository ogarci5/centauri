class Group < ActiveRecord::Base
  has_and_belongs_to_many :resources
  validates :name, uniqueness: true
end
