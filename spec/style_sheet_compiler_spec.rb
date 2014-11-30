require_relative '../lib/style_sheet'
require_relative '../lib/style_sheet_compiler'

describe StyleSheetCompiler do
  let(:compiler) { StyleSheetCompiler.new }

  context 'when compiling to CSS' do
    context 'single style sheet' do
      let(:stylesheet) do
        StyleSheet.new(:cms_post) do
          header do
            title(font: '400 16px Arial')
          end

          intro(margin: '2em 0 0 0')
        end
      end

      before(:each) do
        compiler << stylesheet
      end

      subject { compiler.compile }

      it { is_expected.to include(".cms_post__header__title {\nfont: 400 16px Arial;\n}") }
      it { is_expected.to include(".cms_post__intro {\nmargin: 2em 0 0 0;\n}") }
    end
  end
end