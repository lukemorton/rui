require_relative '../lib/stylesheet'

describe Stylesheet do
  context 'when compiled to bytecode' do
    subject { stylesheet.to_bytecode }

    context 'single definition' do
      let(:stylesheet) do
        Stylesheet.new(:cms_post) do
          title(font: '400 16px Arial')
        end
      end

      it { is_expected.to include(title: [{ font: '400 16px Arial' }]) }
    end

    context 'nested definition' do
      let(:stylesheet) do
        Stylesheet.new(:cms_post) do
          header do
            title(font: '400 16px Arial')
          end

          intro(margin: '2em')

          content(margin: '1em 0 0 0') do
            p(margin: '1em 0 0 0')
          end

          footer(margin: '2em 0 0 0') do
            cite(font: { style: :italic })
          end
        end
      end

      it { is_expected.to include(header: [{ title: [{ font: '400 16px Arial' }] }]) }
      it { is_expected.to include(intro: [{ margin: '2em' }]) }
      it { is_expected.to include(content: [{ margin: '1em 0 0 0' },
                                            { p: [{ margin: '1em 0 0 0' }] }]) }
      it { is_expected.to include(footer: [{ margin: '2em 0 0 0' },
                                            { cite: [{ font: { style: :italic } }] }]) }
    end
  end
end
