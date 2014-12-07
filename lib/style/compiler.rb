require_relative './rules_resolver'
require_relative './rules_merger'

module Style
  class Compiler
    def initialize
      @sheets = []
      @rules_resolver = RulesResolver.new
      @rules_merger = RulesMerger.new
    end

    def <<(sheet)
      sheets << sheet
      rules_resolver << { sheet.name => sheet.abstract_rules }
    end

    def compile
      rules_merger.rules = rules_resolver.resolve
      css = compiled_standalone_css
      "#{compiled_merged_css}\n\n#{css}"
    end

    private

    attr_reader :sheets, :rules_resolver, :rules_merger

    def compiled_standalone_css
      sheets.map { |sheet| compile_sheet(sheet) }.join("\n\n")
    end

    def compiled_merged_css
      rules_merger.merged_rules.map do |(selectors, rule)|
        define_rule(selectors.join(', '), rule)
      end.join("\n\n")
    end

    def compile_sheet(sheet)
      sheet.to_bytecode.map do |element, styles|
        define_rule(".#{sheet.name}__#{element}", styles)
      end
    end

    def define_rule(rule_selector, rule)
      rules_merger.add_rule_extensions(rule_selector, rule[:extends])

      rule_css = []

      css_props = define_properties(rule[:properties])

      unless css_props.empty?
        rule_css << "#{rule_selector} {\n#{css_props}\n}"
      end

      rule_css.concat(define_rules(rule_selector, rule[:pseudo], ':'))
      rule_css.concat(define_rules(rule_selector, rule[:children], '__'))

      rule_css.join("\n")
    end

    def define_rules(parent_selector, rules, separator)
      rules.map do |selector, rule|
        define_rule("#{parent_selector}#{separator}#{selector}", rule)
      end
    end

    def define_properties(properties)
      properties.map { |p, v| "#{p}: #{v};" }.join("\n")
    end
  end
end
