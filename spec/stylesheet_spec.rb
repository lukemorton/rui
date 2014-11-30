require_relative '../lib/stylesheet'

describe Stylesheet do
  let(:stylesheet) do
    described_class.new(:cms_post) do
      title(font: '400 16px Arial')
    end
  end

  context 'when compiled to bytecode' do
    subject { stylesheet.to_bytecode }

    it { is_expected.to include(title: [{ font: '400 16px Arial' }]) }
  end
end
