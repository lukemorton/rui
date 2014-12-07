# <div class="error_label">
#   <label for="<%= for %>"
#          class="error_label__label">
#     <%= error %>
#   </label>
# </div>
#
Component.new(:error_label) do |component, errors|
  if errors.count > 0
    label(for: for) { errors.join(' ') }
  end
end
