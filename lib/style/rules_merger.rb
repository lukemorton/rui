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

    def add_rule_extensions(rule, extensions)
      if extensions
        extensions.each do |ss_name, rules|
          rules = [rules] unless rules.is_a?(Array)

          rules.map { |rule| [ss_name, rule] }.each do |extension_key|
            merged_rule_selectors[extension_key] ||= []
            merged_rule_selectors[extension_key] << rule
          end
        end
      end
    end

    def merge_extensions(rule)
      if rule[:extends]
        rule[:extends].reduce(rule[:properties]) do |properties, (ss_name, rules)|
          rules = [rules] unless rules.is_a?(Array)

          rules.map { |rule| [ss_name, rule] }.reduce(properties) do |properties, extensions_key|
            properties.merge(extensions_rules[extensions_key][:properties])
          end
        end
      else
        rule[:properties]
      end
    end

    def merged_rules
      merged_rule_selectors.map do |extensions_key, rules|
        [rules, extensions_rules[extensions_key]]
      end
    end

    private

    attr_reader :extensions_rules, :merged_rule_selectors
  end
end
