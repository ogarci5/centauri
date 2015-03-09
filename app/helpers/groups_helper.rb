module GroupsHelper

  def children_names(group)
    group.groups.map(&:name).sort.join('<br>').html_safe.presence || 'None'
  end

end
