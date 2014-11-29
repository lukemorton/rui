# .error_label {}
# .error_label__label {
#   @include block;
#   color: red;
# }
#
StyleSheet.new(:error_label) do
  label(display: :block, color: :red)
end
