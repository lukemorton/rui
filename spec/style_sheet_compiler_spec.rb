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

          intro(margin: '2em 0 0 0')

          content(margin: '1em 0 0 0') do
            p(margin: '1em 0 0 0')
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
      it { is_expected.to include(".cms_post__intro {\nmargin: 2em 0 0 0;\n}") }
      it { is_expected.to include(".cms_post__content {\nmargin: 1em 0 0 0;\n}") }
      it { is_expected.to include(".cms_post__content__p {\nmargin: 1em 0 0 0;\n}") }
      it { is_expected.to include(".cms_post__footer {\nmargin: 2em 0 0 0;\n}") }
      it { is_expected.to include(".cms_post__footer__cite {\nbackground: grey;\nfont-style: italic;\n}") }
    end

    context 'single style sheet with abstractions' do
      let(:typography_style_sheet) do
        Style::Sheet.new(:typography) do
          abstract(:standard, font: '400 16px Arial')
          abstract(:title, font: { family: 'Georgia' }).extend(typography: :standard)
          abstract(:large, font: { size: '3em' })
        end
      end

      let(:page_style_sheet) do
        Style::Sheet.new(:page) do
          title.extend(typography: [:title, :large])

          sub_title.extend(typography: :title)

          content.extend(typography: :standard) do
            p(margin: { top: '1.5em' })
          end
        end
      end

      before(:each) do
        compiler << typography_style_sheet
        compiler << page_style_sheet
      end

      it { is_expected.to include(".page__title, .page__sub_title {\nfont: 400 16px Arial;\nfont-family: Georgia;\n}") }
      it { is_expected.to include(".page__title {\nfont-size: 3em;\n}") }
      it { is_expected.to include(".page__content {\nfont: 400 16px Arial;\n}") }
      it { is_expected.to include(".page__content__p {\nmargin-top: 1.5em;\n}") }
    end
  end
end
