class Group < ActiveRecord::Base
  has_and_belongs_to_many :resources
  has_many :groups
  belongs_to :parent, class_name: 'Group', foreign_key: :group_id

  scope :main, -> { where(main: true) }

  validates :name, uniqueness: true
end
