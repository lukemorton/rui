require_relative './context'

module Style
  class Rule < Hash
    PSEUDO_SELECTORS = [:hover, :active, :visited]

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

    def [](key)
      if PSEUDO_SELECTORS.include?(key)
        self[:pseudo][key] || set_pseudo_selector(key)
      else
        super
      end
    end

    def []=(key, value)
      if PSEUDO_SELECTORS.include?(key)
        set_pseudo_selector(key, value)
      else
        super
      end
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

    def set_pseudo_selector(selector, properties = {})
      self[:pseudo][selector.to_s.gsub('_', '-').to_sym] = Rule.new(properties)
    end
  end
end
