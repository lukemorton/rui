require_relative './context'

module Style
  class Rule < Hash
    def initialize(properties, &block)
      merge!(properties: expand_properties(properties || {}),
             extends: {},
             pseudo: {},
             children: Context.new)

      context(&block)
    end

    def context(&block)
      if block_given?
        self[:children].instance_exec(self, &block)
      end

      self
    end

    def extend(extensions, &block)
      self[:extends] = extensions
      context(&block)
    end

    def when(selector, properties = {}, &block)
      self[:pseudo][selector.to_s.gsub('_', '-').to_sym] = Rule.new(properties, &block)
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
          properties.merge(property.to_s.gsub('_', '-').to_sym => value)
        end
      end
    end
  end
end
