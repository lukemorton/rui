sheet = Style::Sheet.new(:example) do
  section.extend(base: :font)
end

Style::Registry.register(sheet)
