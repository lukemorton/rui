sheet = Style::Sheet.new(:base) do
  abstract(:font, font: '12px Arial')
end

Style::Registry.register(sheet)
