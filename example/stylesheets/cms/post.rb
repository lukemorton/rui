# .cms_post {}
# .cms_post__article {}
# .cms_post__article__header {}
# .cms_post__article__header__title {
#   @extend %typography__title;
#   @extend %typography__large;
# }
# .cms_post__article__intro {
#   @extend %typography__important;
#   margin-top: 2em;
# }
# .cms_post__article__content {
#   @extend %typography__standard;
# }
# .cms_post__article__content__p {
#   margin-top: 1.5em;
# }
# .cms_post__article__content__a {
#   color: black;
#
#   &:hover { color: red; }
#   &:visited { color: grey; }
# }
# .cms_post__article__footer {
#   margin-top: 1.5em;
# }
# .cms_post__article__footer__cite {
#   @extend %typography__emphasis;
# }
# .cms_post--lightbox {
#   .cms_post__overlay {
#     position: absolute;
#     background: rgba(0,0,0, 0.5);
#     width: 100%;
#     height: 100%;
#   }
#   .cms_post__article {
#     position: absolute;
#     top: 5%;
#     right: 5%;
#     bottom: 5%;
#     left: 5%;
#     max-width: 600px;
#   }
# }
# @media (min-width: 800px) {
#   .cms_post__article { max-width: 800px; }
# }
#
StyleSheet.new(:cms_post) do |s|
  article do
    header do
      title.extend(typography: [:title, :large])
    end

    intro(margin_top: '2em').extend(typography: :important)

    content do |content|
      content.extend(typography: :standard)

      p(margin_top: '1.5em')

      a(color: :black) do |a|
        a[:hover] = { color: :red }
        a[:visited] = { color: :grey }
      end
    end

    footer(margin_top: '2em') do
      cite.extend(typography: :emphasis)
    end
  end

  s.modifier(:lightbox) do
    overlay(position: :absolute,
            background: 'rgba(0,0,0, 0.5)',
            width: '100%',
            height: '100%')

    article(position: :absolute,
            top: '5%',
            right: '5%',
            bottom: '5%',
            left: '5%',
            max_width: '600px')
  end

  s.media(min_width: '800px') do
    article(max_width: '800px')
  end
end
