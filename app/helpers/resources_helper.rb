module ResourcesHelper

  def toggle_groups_button(toggle)
    button_tag(id: 'toggle-groups', class: "btn btn-default #{toggle ? 'active' : ''}",
                                 autocomplete: 'off', :'data-toggle' => 'button',  :'aria-pressed' => !toggle) do
      'Toggle Groups  <span class="glyphicon glyphicon-expand"></span>'.html_safe
    end
  end
end
