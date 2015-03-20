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
      sheets.map { |sheet| compile_sheet(sheet) }.join("\n\n")
    end

    private

    attr_reader :sheets, :rules_resolver, :rules_merger

    def compile_sheet(sheet)
      sheet.to_bytecode.map do |element, styles|
        define_rule(".#{sheet.name}__#{element}", styles)
      end
    end

    def define_rule(rule_selector, rule, child_prefix = '')
      properties = rules_merger.merge_extensions(rule)

      rule_css = []

      css_props = define_properties(properties)

      unless css_props.empty?
        rule_css << "#{rule_selector} {\n#{css_props}\n}"
      end

      rule_css.concat(define_pseudo_rules("#{child_prefix}#{rule_selector}", rule[:pseudo]))
      rule_css.concat(define_child_rules("#{child_prefix}#{rule_selector}", rule[:children]))

      rule_css.join("\n")
    end

    def define_pseudo_rules(rule_selector, rules)
      rules.map do |selector, rule|
        pseudo_selector = "#{rule_selector}:#{selector}"
        define_rule(pseudo_selector, rule, "#{pseudo_selector} #{rule_selector}")
      end
    end

    def define_child_rules(rule_selector, rules)
      rules.map do |selector, rule|
        define_rule("#{rule_selector}__#{selector}", rule)
      end
    end

    def define_properties(properties)
      properties.map { |p, v| "#{p}: #{v};" }.join("\n")
    end
  end
end
