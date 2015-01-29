module ResourcesHelper

  def toggle_groups_button(toggle)
    button_tag('Toggle Groups', {id: 'toggle-groups', class: "btn btn-default #{toggle ? 'active' : ''}",
                                 autocomplete: 'off', :'data-toggle' => 'button',  :'aria-pressed' => !toggle})
  end
end
