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
    sheet.to_bytecode.map { |k, v| define_rule(sheet.name, k, v) }
  end

  def define_rule(ns, k, v)
    ".#{ns}__#{k} {\n#{define_properties(v[0])}\n}"
  end

  def define_properties(properties)
    properties.map { |p, v| "#{p}: #{v};" }.join("\n")
  end
end
