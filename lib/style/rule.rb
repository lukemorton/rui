require_relative './context'

module Style
  class Rule < Hash
    def initialize(properties, &block)
      self[:properties] = expand_properties(properties || {})
      self[:extends] = {}
      self[:children] = Context.new(&block)
    end

    def extend(extensions)
      self[:extends] = extensions
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
  end
end
