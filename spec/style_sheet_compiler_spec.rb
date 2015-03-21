require_relative '../lib/style/sheet'
require_relative '../lib/style/compiler'

describe Style::Compiler do
  let(:compiler) { Style::Compiler.new }

  subject { compiler.compile }

  context 'when compiling to CSS' do
    context 'single style sheet' do
      let(:stylesheet) do
        Style::Sheet.new(:cms_post) do
          header do
            title(font: '400 16px Arial')
          end

          intro(margin_top: '2em')

          content(margin: { top: '1em' }) do
            p(margin: '1em 0 0 0')

            a(color: :black) do |a|
              a.when(:hover, color: :red)
              a.when(:visited, color: :grey)
            end
          end

          footer(margin: '2em 0 0 0') do
            cite(background: :grey, font: { style: :italic })
          end
        end
      end

      before(:each) do
        compiler << stylesheet
      end

      it { is_expected.to include(".cms_post__header__title {\nfont: 400 16px Arial;\n}") }
      it { is_expected.to include(".cms_post__intro {\nmargin-top: 2em;\n}") }
      it { is_expected.to include(".cms_post__content {\nmargin-top: 1em;\n}") }
      it { is_expected.to include(".cms_post__content__p {\nmargin: 1em 0 0 0;\n}") }
      it { is_expected.to include(".cms_post__content__a {\ncolor: black;\n}") }
      it { is_expected.to include(".cms_post__content__a:hover {\ncolor: red;\n}") }
      it { is_expected.to include(".cms_post__content__a:visited {\ncolor: grey;\n}") }
      it { is_expected.to include(".cms_post__footer {\nmargin: 2em 0 0 0;\n}") }
      it { is_expected.to include(".cms_post__footer__cite {\nbackground: grey;\nfont-style: italic;\n}") }
    end

    context 'style sheets with abstractions' do
      let(:typography_style_sheet) do
        Style::Sheet.new(:typography) do
          abstract(:standard, font: '400 16px Arial')
          abstract(:title, font_family: 'Georgia').extend(typography: :standard)
          abstract(:large, font: { size: '3em' })
        end
      end

      let(:page_style_sheet) do
        Style::Sheet.new(:page) do
          title.extend(typography: [:title, :large])

          sub_title.extend(typography: :title)

          content do |content|
            content.extend(typography: :standard)

            p(margin: { top: '1.5em' })

            a(color: :black) do |a|
              help(display: :none)

              a.when(:hover, color: :red) do
                help(display: :block)
              end

              a.when(:visited, color: :grey)
            end
          end
        end
      end

      before(:each) do
        compiler << typography_style_sheet
        compiler << page_style_sheet
      end

      it { is_expected.to include(".page__title {\nfont: 400 16px Arial;\nfont-family: Georgia;\nfont-size: 3em;\n}") }
      it { is_expected.to include(".page__sub_title {\nfont: 400 16px Arial;\nfont-family: Georgia;\n}") }
      it { is_expected.to include(".page__content {\nfont: 400 16px Arial;\n}") }
      it { is_expected.to include(".page__content__p {\nmargin-top: 1.5em;\n}") }
      it { is_expected.to include(".page__content__a {\ncolor: black;\n}") }
      it { is_expected.to include(".page__content__a:hover {\ncolor: red;\n}") }
      it { is_expected.to include(".page__content__a:visited {\ncolor: grey;\n}") }
      it { is_expected.to include(".page__content__a__help {\ndisplay: none;\n}") }
      it { is_expected.to include(".page__content__a:hover .page__content__a__help {\ndisplay: block;\n}") }
    end

    context 'when style sheet contains media queries' do
      let(:media_style_sheet) do
        Style::Sheet.new(:article) do |s|
          s.media(min_width: '50em') do
            article(max_width: '50em')
          end

          s.media(min_width: '50em', max_width: '100em') do
            article(max_width: '50em')

            header do
              a(float: :none)
            end
          end
        end
      end

      before(:each) do
        compiler << media_style_sheet
      end

      it { is_expected.to include("@media (min-width: 50em)") }
      it { is_expected.to include("@media (min-width: 50em) and (max-width: 100em)") }
    end
  end
end
