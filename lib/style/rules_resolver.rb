module Style
  class RulesResolver
    def initialize
      @unresolved_rules = {}
    end

    def <<(abstractions)
      @unresolved_rules.merge!(abstractions)
    end

    def resolve
      @resolved_rules = begin
        @unresolved_rules.reduce({}) do |resolved_stylesheets, (style_sheet, rules)|
          resolved_stylesheets.merge(style_sheet => resolved_rules(rules))
        end
      end
    end

    private

    def resolved_rules(rules)
      rules.reduce({}) do |resolved_rules, (rule_name, rule)|
        props = properties_from_unresolved_rules(rule[:extends]).merge(rule[:properties])
        resolved_rules.merge(rule_name => { properties: props })
      end
    end

    def properties_from_unresolved_rules(extensions)
      (extensions || {}).reduce({}) do |properties, (style_sheet, rule_names)|
        properties.merge(properties_from(@unresolved_rules, style_sheet, rule_names))
      end
    end

    def properties_from(rules, style_sheet, rule_names)
      unless rule_names.is_a?(Array)
        rule_names = [rule_names]
      end

      rule_names.reduce({}) do |properties, rule_name|
        properties.merge(rules[style_sheet][rule_name][:properties])
      end
    end
  end
end
