require_relative './rules_resolver'

module Style
  class Compiler
    def initialize
      @sheets = []
      @rules_resolver = RulesResolver.new
    end

    def <<(sheet)
      sheets << sheet
      rules_resolver << { sheet.name => sheet.abstract_rules }
    end

    def compile
      rules_resolver.resolve!
      sheets.map { |sheet| compile_sheet(sheet) }.join("\n\n")
    end

    private

    attr_reader :sheets, :rules_resolver

    def compile_sheet(sheet)
      sheet.to_bytecode.map { |element, styles| define_rule(sheet.name, element, styles) }
    end

    def define_rule(ns, element, styles)
      abstract_properties = rules_resolver.properties(styles[:extends])
      properties = define_properties(styles[:properties].merge(abstract_properties))

      rule = [".#{ns}__#{element} {\n#{properties}\n}"]

      unless styles[:children].nil?
        styles[:children].each do |child_element, child_styles|
          rule << define_rule("#{ns}__#{element}", child_element, child_styles)
        end
      end

      rule.join("\n")
    end

    def define_properties(properties)
      properties.map { |p, v| "#{p}: #{v};" }.join("\n")
    end
  end
end
