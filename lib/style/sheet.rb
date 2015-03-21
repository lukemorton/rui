require_relative './context'

module Style
  class Sheet
    attr_reader :name

    def initialize(name, &block)
      @name = name
      @media = []
      @context = Context.new
      @context.instance_exec(self, &block)
    end

    def media(query = nil, &block)
      return @media if query.nil?
      @media << [format_props(query), Context.new(&block)]
    end

    def context
      @context
    end

    def abstract_rules
      @context.abstract_rules
    end

    private

    def format_props(props)
      props.reduce({}) do |formatted, (prop, value)|
        formatted.merge(prop.to_s.gsub('_', '-').to_sym => value)
      end
    end
  end
end
