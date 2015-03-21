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

    def extend(extensions)
      merge!(extends: extensions)
    end

    def pseudo(selector, properties = {}, &block)
      self[:pseudo][selector.to_s.gsub('_', '-').to_sym] = Rule.new(properties, &block)
      self
    end
    alias_method :when, :pseudo
    alias_method :on, :pseudo

    def focus(properties = {}, &block)
      pseudo(:focus, properties, &block)
    end

    def hover(properties = {}, &block)
      pseudo(:hover, properties, &block)
    end

    def visited(properties = {}, &block)
      pseudo(:visited, properties, &block)
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
