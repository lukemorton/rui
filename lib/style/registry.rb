module Style
  class Registry < Array
    class << self
      def register_dir(dir)
        registry.register_dir(dir)
      end

      def register(sheet)
        registry << sheet
      end

      def sheets
        registry
      end

      private

      def registry
        @registry ||= new
      end
    end

    def register_dir(dir)
      Dir[File.join(dir, '**/*.rb')].each { |f| load(f) }
    end

    alias_method :register, :<<
  end
end
