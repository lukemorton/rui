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
    resolve_abstractions!
    @sheets.map { |sheet| compile_sheet(sheet) }.join("\n\n")
  end

  private

  def resolve_abstractions!
    @abstractions = @abstractions.reduce({}) do |resolved_stylesheets, (abstract_ss, abstractions)|
      resolved_abstractions = abstractions.reduce({}) do |resolved_abstractions, (abstraction, styles)|
        if styles[:extends]
          properties = extended_properties(styles[:extends]).merge(styles[:properties])
          resolved_abstractions.merge(abstraction => { properties: properties })
        else
          resolved_abstractions.merge(abstraction => styles)
        end
      end

      resolved_stylesheets.merge(abstract_ss => resolved_abstractions)
    end
  end

  def extended_properties(abstractions)
    abstractions.reduce({}) do |extended_properties, (abstract_ss, abstractions)|
      if @abstractions[abstract_ss]
        abstractions = [abstractions] unless abstractions.is_a?(Array)

        abstraction_styles = abstractions.reduce({}) do |styles, abstraction|
          if @abstractions[abstract_ss][abstraction]
            styles.merge(@abstractions[abstract_ss][abstraction][:properties])
          else
            styles
          end
        end

        extended_properties.merge(abstraction_styles)
      else
        extended_properties
      end
    end
  end

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
      styles[:children].each do |child_element, child_styles|
        rule << define_rule("#{ns}__#{element}", child_element, child_styles)
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
            define_properties(@abstractions[abstract_ss][abstraction][:properties])
          end
        end
      end
    end.flatten.join("\n")
  end

  def define_properties(properties)
    properties.map { |p, v| "#{p}: #{v};" }.join("\n")
  end
end
