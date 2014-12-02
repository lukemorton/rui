require_relative './style_sheet_abstraction_resolver'

class StyleSheetCompiler
  def initialize
    @sheets = []
    @abstraction_resolver = StyleSheetAbstractionResolver.new
  end

  def <<(sheet)
    sheets << sheet
    abstraction_resolver << { sheet.name => sheet.abstractions }
  end

  def compile
    @abstractions = abstraction_resolver.resolve!
    sheets.map { |sheet| compile_sheet(sheet) }.join("\n\n")
  end

  private

  attr_reader :sheets, :abstraction_resolver

  def compile_sheet(sheet)
    sheet.to_bytecode.map { |element, styles| define_rule(sheet.name, element, styles) }
  end

  def define_rule(ns, element, styles)
    abstract_properties = abstraction_resolver.properties(styles[:extends])
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
