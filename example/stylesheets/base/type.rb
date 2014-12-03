# %type__standard {
#   font: {
#     family: Georgia;
#     weight: 200;
#   }
# }
# %type__title {
#   @extend %type__standard;

#   font: {
#     family: Arial;
#   }
# }
# %type__heavy {
#   font: {
#     weight: 400;
#   }
# }
# %type__emphasis {
#   font: {
#     style: italic;
#   }
# }
# %type__small {
#   font: {
#     size: 0.8em;
#   }
# }
# %type__important {
#   font: {
#     size: 1.6em;
#   }
# }
# %type__large {
#   font: {
#     size: 3em;
#   }
# }

StyleSheet.new(:type) do
  abstract(:standard, font: '400 12px Georgia')
  abstract(:title, font: { family: :Arial }).extend(type: :standard)

  abstract(:heavy, font: { weight: 400 })
  abstract(:emphasis, font: { style: :italic })

  abstract(:small, font: { size: '0.8em' })
  abstract(:important, font: { size: '1.6em' })
  abstract(:large, font: { size: '3em' })
end
