require_relative '../lib/stylesheet'

describe Stylesheet do
  context 'when compiled to bytecode' do
    subject { stylesheet.to_bytecode }

    context 'single definition' do
      let(:stylesheet) do
        described_class.new(:cms_post) do
          title(font: '400 16px Arial')
        end
      end

      it { is_expected.to include(title: [{ font: '400 16px Arial' }]) }
    end

    context 'nested definition' do
      let(:stylesheet) do
        described_class.new(:cms_post) do
          header do
            title(font: '400 16px Arial')
          end
        end
      end

      it { is_expected.to include(header: { title: [{ font: '400 16px Arial' }] }) }
    end
  end
end
