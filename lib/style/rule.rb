require_relative './context'

module Style
  class Rule < Hash
    PSEUDO_SELECTORS = [:hover, :active, :visited]

    def initialize(properties, &block)
      merge!(properties: expand_properties(properties || {}),
             extends: {},
             children: Context.new)

      eval_in_child_context(&block)
    end

    def extend(extensions, &block)
      self[:extends] = extensions
      eval_in_child_context(&block)
      self
    end

    private

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

    def eval_in_child_context(&block)
      if block_given?
        self[:children].instance_exec(self, &block)
      end
    end
  end
end
