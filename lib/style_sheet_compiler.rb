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

  def define_rule(ns, element, properties_and_children)
    properties, children = properties_and_children.values_at(:properties, :children)
    rule = ".#{ns}__#{element} {\n#{define_properties(properties)}\n}"

    unless children.nil?
      children.each do |child_element, child_properties_and_children|
        rule << "\n" << define_rule("#{ns}__#{element}", child_element, child_properties_and_children)
      end
    end

    rule
  end

  def define_properties(properties)
    properties.map { |p, v| "#{p}: #{v};" }.join("\n")
  end
end
