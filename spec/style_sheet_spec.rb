require_relative '../lib/style/sheet'

describe Style::Sheet do
  context 'when compiled to bytecode' do
    subject { stylesheet.to_bytecode }

    context 'single definition' do
      let(:stylesheet) do
        Style::Sheet.new(:cms_post) do
          title(font: '400 16px Arial')
        end
      end

      it { is_expected.to include(title: { properties: { font: '400 16px Arial' } }) }
    end

    context 'nested definition' do
      let(:stylesheet) do
        Style::Sheet.new(:cms_post) do
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

      it { is_expected.to include(header: { properties: {},
                                            children: { title: { properties: { font: '400 16px Arial' } } } }) }

      it { is_expected.to include(intro: { properties: { margin: '2em' } }) }

      it { is_expected.to include(content: { properties: { margin: '1em 0 0 0' },
                                             children: { p: { properties: { margin: '1em 0 0 0' } } } }) }

      it { is_expected.to include(footer: { properties: { margin: '2em 0 0 0' },
                                            children: { cite: { properties: { 'font-style' => :italic } } } }) }
    end
  end

  context 'abstract rules' do
    subject { stylesheet.abstract_rules }

    let(:stylesheet) do
      Style::Sheet.new(:type) do
        abstract(:standard, font: '400 16px Arial')
      end
    end

    it { is_expected.to include(standard: { properties: { font: '400 16px Arial' } }) }
  end
end
