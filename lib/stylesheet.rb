class Stylesheet
  class Context < Hash
    def initialize(&block)
      instance_eval(&block) if block_given?
    end

    def method_missing(method, *style, &block)
      self[method] = style
    end
  end

  def initialize(name, &block)
    @name = name
    @context = Context.new(&block)
  end

  def to_bytecode
    @context
  end
end
