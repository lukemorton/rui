# %type__standard {
#   font: {
#     family: Georgia;
#     weight: 200;
#   }
# }
# %type__standard {
#   @extend %type__standard;

#   font: {
#     family: Arial;
#     weight: 200;
#   }
# }
# %type__bold {
#   font: {
#     weight: 400;
#   }
# }
StyleSheet.new(:type) do
  abstract(:standard, font: '400 1px Arial')
  abstract(:title, font: { family: :Arial }).extend(:standard)

  abstract(:heavy, font: { weight: 400 })
  abstract(:emphasis, font: { style: :italic })

  abstract(:small, font: { size: '0.8em' })
  abstract(:important, font: { size: '1.6em' })
  abstract(:large, font: { size: '3em' })
end
