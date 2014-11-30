class StyleSheet
  class Context < Hash
    def initialize(&block)
      instance_eval(&block) if block_given?
    end

    def p(styles, &block)
      add_style(:p, styles, &block)
    end

    def method_missing(method, *args, &block)
      add_style(method, args.first, &block)
    end

    private

    def add_style(ns, styles, &block)
      self[ns] = { properties: styles || {} }

      if block_given?
        self[ns][:children] = Context.new(&block)
      end
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
end
