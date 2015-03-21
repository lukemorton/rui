require_relative '../../lib/style/sheet'
require_relative '../../lib/style/compiler'

describe Style::Compiler do
  let(:compiler) { Style::Compiler.new }

  subject { compiler.compile }

  context 'when compiling style sheets with abstractions' do
    let(:typography_style_sheet) do
      Style::Sheet.new(:typography) do
        abstract(:standard, font: '400 16px Arial')
        abstract(:title, font_family: 'Georgia').extend(typography: :standard)
        abstract(:small, font: { size: '.8em' })
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
              help(display: :block).extend(typography: :small)
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
    it { is_expected.to include(".page__content__a:hover .page__content__a__help {\ndisplay: block;\nfont-size: .8em;\n}") }
  end
end
