module SatutempatLocale
  module Server
    class Config
      attr_accessor :locale_path

      def initialize
        @locale_path = 'config/locales'
      end
    end
  end
end
