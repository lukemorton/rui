class StyleSheetAbstractionResolver
  def initialize
    @unresolved_abstractions = {}
  end

  def <<(abstractions)
    @unresolved_abstractions.merge!(abstractions)
  end

  def resolve!
    @resolved_abstractions = @unresolved_abstractions.reduce({}) do |resolved_stylesheets, (abstract_ss, abstractions)|
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

  private

  def extended_properties(abstractions)
    abstractions.reduce({}) do |extended_properties, (abstract_ss, abstractions)|
      if @unresolved_abstractions[abstract_ss]
        abstractions = [abstractions] unless abstractions.is_a?(Array)

        abstraction_styles = abstractions.reduce({}) do |styles, abstraction|
          if @unresolved_abstractions[abstract_ss][abstraction]
            styles.merge(@unresolved_abstractions[abstract_ss][abstraction][:properties])
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
end
