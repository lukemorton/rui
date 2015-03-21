require_relative './rule'

module Style
  class Context < Hash
    attr_reader :abstract_rules

    def initialize(&block)
      @abstract_rules = {}
      instance_exec(&block) if block_given?
    end

    def abstract(abstraction, properties)
      @abstract_rules[abstraction] = Rule.new(properties)
    end

    def p(properties, &block)
      add_rule(:p, properties, &block)
    end

    def method_missing(method, *args, &block)
      add_rule(method, args.first, &block)
    end

    private

    def add_rule(ns, properties, &block)
      self[ns] = Rule.new(properties, &block)
    end
  end
end
