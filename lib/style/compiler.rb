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
      "#{compile_sheets}\n\n#{compile_media_queries}"
    end

    private

    attr_reader :sheets, :rules_resolver, :rules_merger

    def compile_sheets
      sheets.map { |sheet| compile_sheet_context(sheet, sheet.context) }.join("\n\n")
    end

    def compile_media_queries
      sheets.map do |sheet|
        sheet.media.map do |query, context|
          compile_media_query(sheet, query, context)
        end.join("\n\n")
      end.join("\n\n")
    end

    def compile_sheet_context(sheet, context)
      context.map do |element, styles|
        define_rule(".#{sheet.name}__#{element}", styles)
      end
    end

    def compile_media_query(sheet, query, context)
      query_conditions = query.map { |p, v| "(#{p}: #{v})" }.join(' and ')
      css = []
      css << "@media #{query_conditions} {"
      css << compile_sheet_context(sheet, context)
      css << '}'
      css.join("\n")
    end

    def define_rule(rule_selector, rule, child_prefix = '', pseudo = false)
      properties = rules_merger.merge_extensions(rule)

      rule_css = []

      css_props = define_properties(properties)

      unless css_props.empty?
        rule_css << "#{rule_selector} {\n#{css_props}\n}"
      end

      rule_css.concat(define_pseudo_rules("#{child_prefix}#{rule_selector}", rule[:pseudo]))
      rule_selector = '' if pseudo
      rule_css.concat(define_child_rules("#{child_prefix}#{rule_selector}", rule[:children]))

      rule_css.join("\n")
    end

    def define_pseudo_rules(rule_selector, rules)
      rules.map do |selector, rule|
        pseudo_selector = "#{rule_selector}:#{selector}"
        define_rule(pseudo_selector, rule, "#{pseudo_selector} #{rule_selector}", true)
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
