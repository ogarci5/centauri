class Group < ActiveRecord::Base
  has_many :groups_resources
  has_many :resources, through: :groups_resources
  has_many :groups
  belongs_to :parent, class_name: 'Group', foreign_key: :group_id

  scope :main, -> { where(main: true) }
  # Filters are completely separate from other groups.
  scope :filters, -> { where(filter: true) }

  validates :name, uniqueness: true
end
