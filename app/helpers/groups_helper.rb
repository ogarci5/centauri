module GroupsHelper

  def children_names(group)
    group.groups.map(&:name).sort.join('<br>').html_safe.presence || 'None'
  end

  def filter_select(filters, current_filter)
    select_tag :group_id, options_for_select((display_array_descendents(filters) do |group, depth|
                                               ["#{(depth>0 ? ('&nbsp;'* depth)+'- ':'')}#{group.name.titleize}".html_safe, group.id]
                                             end).flatten.each_slice(2).to_a, current_filter), include_blank: 'No Filter', id: 'filter-select'
  end

  def display_array_descendents(array, depth = -1, &block)
    array.map do |element|
      if element.is_a?(Array)
        display_array_descendents(element, depth+1 , &block)
      else
        block.call(element, depth)
      end
    end
  end

end
