module Style
  class Context < Hash
    attr_reader :abstract_rules

    def initialize(&block)
      @abstract_rules = {}
      instance_eval(&block) if block_given?
    end

    def abstract(abstraction, properties)
      @abstract_rules[abstraction] = { properties: expand_properties(properties) }
    end

    def p(properties, &block)
      add_rule(:p, properties, &block)
    end

    def method_missing(method, *args, &block)
      add_rule(method, args.first, &block)
    end

    private

    def add_rule(ns, properties, &block)
      rule = { properties: properties ? expand_properties(properties) : {} }

      if block_given?
        rule[:children] = Context.new(&block)
      end

      self[ns] = rule
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
end
