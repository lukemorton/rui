require 'style/registry'
require 'style/sheet'

describe Style::Registry do
  context 'when loading assets by directory' do
    subject { Style::Registry.sheets }

    let(:dir) { File.join(File.dirname(__FILE__), '/mock/styles') }

    before(:each) { Style::Registry.register_dir(dir) }

    it { is_expected.to include(a_kind_of(Style::Sheet)) }
  end
end
