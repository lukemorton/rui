# .cms_post {}
# .cms_post__header {}
# .cms_post__header__title {
#   @extend %type__title;
#   @extend %type__large;
# }
# .cms_post__intro {
#   @extend %type__important;
# }
# .cms_post__content {}
# .cms_post__footer {}
# .cms_post__footer__cite {}
#
StyleSheet.new(:cms_post) do
  header do
    title.extend(type: [:title, :large])
  end

  intro(margin: '2em').extend(type: :important)

  content(margin: '1em 0 0 0') do
    p(margin: '1em 0 0 0')
  end

  footer(margin: '2em') do
    cite.extend(type: :emphasis)
  end
end
