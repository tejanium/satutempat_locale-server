require 'tempfile'
require 'mongoid'
require 'zlib'
require 'archive/tar/minitar'
require 'satutempat_locale/server/version'
require 'satutempat_locale/server/errors'
require 'satutempat_locale/server/storage'
require 'satutempat_locale/server/push_handler'
require 'satutempat_locale/server/pull_handler'
require 'satutempat_locale/server/global_marker'
require 'satutempat_locale/server/config'

module SatutempatLocale
  module Server
    class Engine < Rails::Engine
    end if defined?(Rails) && Rails::VERSION::MAJOR == 3

    class << self
      attr_accessor :configuration
    end

    def self.configuration
      @configuration ||= Config.new
    end

    def self.configure
      yield configuration
    end

    def self.reset_configuration
      @configuration = Config.new
    end
  end
end
