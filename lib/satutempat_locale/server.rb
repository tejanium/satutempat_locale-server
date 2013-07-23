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

module SatutempatLocale
  module Server
    class Engine < Rails::Engine
    end if defined?(Rails) && Rails::VERSION::MAJOR == 3
  end
end
