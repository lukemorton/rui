require 'style/compiler'

describe Style::Compiler do
  context 'when compiling directory' do
    let(:dir) { File.join(File.dirname(__FILE__), '/../mock/styles') }
    subject { Style::Compiler.compile_dir(dir) }
    it { is_expected.to include(".example__section {\nfont: 12px Arial;\n}") }
  end
end
