require 'style/sheet'
require 'style/compiler'

describe Style::Compiler do
  let(:compiler) { Style::Compiler.new }

  subject { compiler.compile }

  context 'when compiling a single style sheet' do
    let(:stylesheet) do
      Style::Sheet.new(:cms_post) do
        header do
          title(font: '400 16px Arial')
        end

        intro(margin_top: '2em')

        content(margin: { top: '1em' }) do
          p(margin: '1em 0 0 0')

          a(color: :black) do |a|
            help(display: :none)

            a.hover(color: :red) do
              help(display: :block)
            end

            a.focus(color: :grey)
            a.visited(color: :grey)
            a.when(:active, color: :grey)
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
    it { is_expected.to include(".cms_post__content__a__help {\ndisplay: none;\n}") }
    it { is_expected.to include(".cms_post__content__a:hover .cms_post__content__a__help {\ndisplay: block;\n}") }
  end
end
