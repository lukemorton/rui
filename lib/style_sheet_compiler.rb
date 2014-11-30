class StyleSheetCompiler
  def initialize
    @sheets = []
  end

  def <<(sheet)
    @sheets << sheet
  end

  def compile
    @sheets.map { |sheet| compile_sheet(sheet) }.join("\n\n")
  end

  private

  def compile_sheet(sheet)
    sheet.to_bytecode.map { |k, v| define_rule(sheet.name, k, v[:properties]) }
  end

  def define_rule(ns, element, properties)
    ".#{ns}__#{element} {\n#{define_properties(properties)}\n}"
  end

  def define_properties(properties)
    properties.map { |p, v| "#{p}: #{v};" }.join("\n")
  end
end
