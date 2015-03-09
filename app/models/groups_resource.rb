class GroupsResource < ActiveRecord::Base
  belongs_to :group
  belongs_to :resource

  validate :unique_filter

  def unique_filter
    # Is are we trying to add a filter and do we already have a filter?
    if self.group.filter? && self.resource.filter
      errors.add(:group) << 'You may only have one filter at a time.'
    end
  end
end