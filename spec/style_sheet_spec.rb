require 'style/sheet'

describe Style::Sheet do
  context 'when compiled to bytecode' do
    subject { stylesheet.context.to_h }

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
            a.when(:hover, color: :green)
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

  matcher :include_rule_with_properties do |selector, expected|
    match do |actual|
      rule_expectations = { properties: a_hash_including(expected) }
      match(a_hash_including(selector => a_hash_including(rule_expectations)))
    end

    description do
      "include rule with #{expected}"
    end
  end

  matcher :include_pseudo_rule_with_properties do |selector, pseudo_selector, expected|
    match do |actual|
      property_expectations = a_hash_including(properties: expected)
      rule_expectations = { pseudo: { pseudo_selector => property_expectations } }
      match(a_hash_including(selector => a_hash_including(rule_expectations)))
    end

    description do
      "include pseudo rule with #{expected}"
    end
  end

  matcher :include_child_rule_with_properties do |selector, child_selector, expected|
    match do |actual|
      property_expectations = a_hash_including(properties: a_hash_including(expected))
      rule_expectations = { children: a_hash_including(child_selector => property_expectations) }
      match(a_hash_including(selector => a_hash_including(rule_expectations)))
    end

    description do
      "include child rule with #{expected}"
    end
  end

  context 'when registering sheet with registry' do
    subject { Style::Registry.sheets }
    let(:sheet) { Style::Sheet.register(:example) {} }
    it { is_expected.to include(sheet) }
  end
end
