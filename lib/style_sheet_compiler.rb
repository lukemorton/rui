class StyleSheetCompiler
  def initialize
    @sheets = []
    @abstractions = {}
  end

  def <<(sheet)
    @sheets << sheet
    @abstractions.merge!(sheet.name => sheet.abstractions)
  end

  def compile
    @sheets.map { |sheet| compile_sheet(sheet) }.join("\n\n")
  end

  private

  def compile_sheet(sheet)
    sheet.to_bytecode.map { |element, styles| define_rule(sheet.name, element, styles) }
  end

  def define_rule(ns, element, styles)
    rule = [".#{ns}__#{element} {"]

    unless styles[:extends].nil?
      rule << define_abstract_properties(styles[:extends])
    end

    unless styles[:properties].empty?
      rule << define_properties(styles[:properties])
    end

    rule << '}'

    unless styles[:children].nil?
      styles[:children].each do |child_element, child_properties_and_children|
        rule << define_rule("#{ns}__#{element}", child_element, child_properties_and_children)
      end
    end

    rule.join("\n")
  end

  def define_abstract_properties(abstractions)
    abstractions.map do |abstract_ss, abstractions|
      if @abstractions[abstract_ss]
        abstractions = [abstractions] unless abstractions.is_a?(Array)

        abstractions.map do |abstraction|
          if @abstractions[abstract_ss][abstraction]
            define_properties(@abstractions[abstract_ss][abstraction])
          end
        end
      end
    end.flatten.join("\n")
  end

  def define_properties(properties)
    expand_properties(properties).map { |p, v| "#{p}: #{v};" }.join("\n")
  end

  def expand_properties(properties)
    properties.reduce({}) do |properties, (property, value)|
      if value.is_a?(Hash)
        sub_properties = value.reduce({}) do |sub_properties, (sub_property, value)|
          sub_properties.merge("#{property}-#{sub_property}" => value)
        end

        properties.merge(sub_properties)
      else
        properties.merge(property => value)
      end
    end
  end
end
