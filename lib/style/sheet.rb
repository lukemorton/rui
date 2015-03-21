require_relative './context'

module Style
  class Sheet
    attr_reader :name

    def initialize(name, &block)
      @name = name
      @context = Context.new(&block)
    end

    def context
      @context
    end

    def abstract_rules
      @context.abstract_rules
    end
  end
end
