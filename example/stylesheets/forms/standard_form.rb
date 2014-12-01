# .standard_form {}
# .standard_form__field {
#   @include cf;
# }
# .standard_form__field__label {
#   display: block;
#   @extend %type_standard;
#   @extend %type_bold;
# }
# .standard_form__field__input {
#   appearance: none;
# }
# .standard_form__buttons {
#   @include cf;
# }
# .standard_form__buttons__button {
#   appearance: none;
#   background: blue;
# }
#
StyleSheet.new(:standard_form) do
  field.include(:cf) do
    label(display: :block).merge!(extends: { type: [:standard, :heavy] })
    input(appearance: :none, border: '1px solid grey')
  end

  buttons.include(:cf) do
    button(appearance: :none, background: :blue)
  end
end
