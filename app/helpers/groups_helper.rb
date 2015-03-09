module GroupsHelper

  def children_names(group)
    group.groups.map(&:name).sort.join('<br>').html_safe.presence || 'None'
  end

  def filter_select(filters)
    select_tag :group_id, display_array_descendents(filters) {|group, depth| [group.id, "#{'-' * depth} #{group.name}"]}
  end

  def display_array_descendents(array, depth = -1, &block)
    array.map do |element|
      if element.is_a?(Array)
        display_array_descendents(element,depth+1)
      else
        block.call(element, depth)
      end
    end
  end

end
