sheet = Style::Sheet.new(:all) do
  section.extend(base: :font)
end

Style::Registry.register(sheet)
