class StyleSheet
  class Context < Hash
    attr_reader :abstractions

    def initialize(&block)
      @abstractions = {}
      instance_eval(&block) if block_given?
    end

    def abstract(abstraction, properties)
      @abstractions[abstraction] = { properties: properties }
    end

    def p(properties, &block)
      add_style(:p, properties, &block)
    end

    def method_missing(method, *args, &block)
      add_style(method, args.first, &block)
    end

    private

    def add_style(ns, properties, &block)
      styles = { properties: properties || {} }

      if block_given?
        styles[:children] = Context.new(&block)
      end

      self[ns] = styles
    end
  end

  attr_reader :name

  def initialize(name, &block)
    @name = name
    @context = Context.new(&block)
  end

  def to_bytecode
    @context
  end

  def abstractions
    @context.abstractions
  end
end
