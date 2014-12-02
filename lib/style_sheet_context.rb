class StyleSheetContext < Hash
  attr_reader :abstractions

  def initialize(&block)
    @abstractions = {}
    instance_eval(&block) if block_given?
  end

  def abstract(abstraction, properties)
    @abstractions[abstraction] = { properties: expand_properties(properties) }
  end

  def p(properties, &block)
    add_style(:p, properties, &block)
  end

  def method_missing(method, *args, &block)
    add_style(method, args.first, &block)
  end

  private

  def add_style(ns, properties, &block)
    styles = { properties: properties ? expand_properties(properties) : {} }

    if block_given?
      styles[:children] = StyleSheetContext.new(&block)
    end

    self[ns] = styles
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
