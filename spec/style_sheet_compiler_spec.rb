require_relative '../lib/style_sheet'
require_relative '../lib/style_sheet_compiler'

describe StyleSheetCompiler do
  let(:compiler) { StyleSheetCompiler.new }

  context 'when compiling to CSS' do
    context 'single style sheet' do
      let(:stylesheet) do
        StyleSheet.new(:cms_post) do
          title(font: '400 16px Arial')
        end
      end

      before(:each) do
        compiler << stylesheet
      end

      subject { compiler.compile }

      it { is_expected.to eq(".cms_post__title {\nfont: 400 16px Arial;\n}") }
    end
  end
end
