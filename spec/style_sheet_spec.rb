require_relative '../lib/style/sheet'

describe Style::Sheet do
  context 'when compiled to bytecode' do
    subject { stylesheet.to_bytecode.to_h }

    context 'single definition' do
      let(:stylesheet) do
        Style::Sheet.new(:cms_post) do
          title(font: '400 16px Arial')
        end
      end

      it { is_expected.to include_rule_with_properties(:title, font: '400 16px Arial') }
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

          a do |a|
            help(display: :none)

            a[:hover].context do |hover|
              hover[:properties] = { color: :green }
              help(display: :block)
            end
          end

          footer(margin: '2em 0 0 0') do
            cite(font: { style: :italic })
          end
        end
      end

      it { is_expected.to include_child_rule_with_properties(:header, :title, font: '400 16px Arial') }

      it { is_expected.to include_rule_with_properties(:intro, margin: '2em') }

      it { is_expected.to include_rule_with_properties(:content, margin: '1em 0 0 0') }
      it { is_expected.to include_child_rule_with_properties(:content, :p, margin: '1em 0 0 0') }
      it { is_expected.to include_pseudo_rule_with_properties(:a, :hover, color: :green) }

      it { is_expected.to include_rule_with_properties(:footer, margin: '2em 0 0 0') }
      it { is_expected.to include_child_rule_with_properties(:footer, :cite, 'font-style' => :italic) }
    end
  end

  context 'abstract rules' do
    subject { stylesheet.abstract_rules.to_h }

    let(:stylesheet) do
      Style::Sheet.new(:typography) do
        abstract(:standard, font: '400 16px Arial')
      end
    end

    it { is_expected.to include_rule_with_properties(:standard, font: '400 16px Arial') }
  end

  def include_rule_with_properties(selector, property_expectations)
    rule_expectations = { properties: a_hash_including(property_expectations) }
    match(a_hash_including(selector => a_hash_including(rule_expectations)))
  end

  def include_pseudo_rule_with_properties(selector, pseudo_selector, property_expectations)
    property_expectations = a_hash_including(properties: property_expectations)
    rule_expectations = { pseudo: { pseudo_selector => property_expectations } }
    match(a_hash_including(selector => a_hash_including(rule_expectations)))
  end

  def include_child_rule_with_properties(selector, child_selector, property_expectations)
    property_expectations = a_hash_including(properties: a_hash_including(property_expectations))
    rule_expectations = { children: a_hash_including(child_selector => property_expectations) }
    match(a_hash_including(selector => a_hash_including(rule_expectations)))
  end
end
