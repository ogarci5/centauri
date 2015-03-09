class Group < ActiveRecord::Base
  has_many :groups_resources
  has_many :resources, through: :groups_resources
  has_many :groups
  belongs_to :parent, class_name: 'Group', foreign_key: :group_id

  scope :main, -> { where(main: true) }
  # Filters are completely separate from other groups.
  scope :filters, -> { where(filter: true) }
  scope :not_filters, -> { where(filter: false) }
  scope :top_filters, -> { where(filter: true, group_id: nil) }

  def self.filter_hierarchy
    top_filters.map(&:self_with_descendents)
  end

  def descendents
    groups.map do |group|
      [group] + group.descendents
    end
  end

  def self_with_descendents
    [self] + descendents
  end

  validates :name, uniqueness: true
end
