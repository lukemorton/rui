require_relative './style_sheet_context'

class StyleSheet
  attr_reader :name

  def initialize(name, &block)
    @name = name
    @context = StyleSheetContext.new(&block)
  end

  def to_bytecode
    @context
  end

  def abstract_rules
    @context.abstract_rules
  end
end
