module Style
  class RulesMerger
    def initialize
      @merged_rule_selectors = {}
    end

    def rules=(rules)
      @extensions_rules = rules.reduce({}) do |extensions_rules, (ss_name, extensions)|
        extensions.each do |rule_name, rule|
          extensions_rules.merge!([ss_name, rule_name] => rule)
        end

        extensions_rules
      end
    end

    def merge_extensions(rule)
      rule[:extends].reduce(rule[:properties]) do |properties, (ss_name, rules)|
        rules = [rules] unless rules.is_a?(Array)

        rules.map { |rule| [ss_name, rule] }.reduce(properties) do |properties, extensions_key|
          properties.merge(extensions_rules[extensions_key][:properties])
        end
      end
    end

    private

    attr_reader :extensions_rules, :merged_rule_selectors
  end
end
