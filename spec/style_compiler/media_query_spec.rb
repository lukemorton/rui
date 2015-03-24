require_relative '../../lib/style/sheet'
require_relative '../../lib/style/compiler'

describe Style::Compiler do
  let(:compiler) { Style::Compiler.new }

  subject { compiler.compile }

  context 'when compiling a style sheet that contains media queries' do
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

    it { is_expected.to include('@media (min-width: 50em)') }
    it { is_expected.to include('@media (min-width: 50em) and (max-width: 100em)') }
    it { is_expected.to include(".article__header__a {\nfloat: none;\n}") }
  end
end
