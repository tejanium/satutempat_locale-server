# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'satutempat_locale/server/version'

Gem::Specification.new do |spec|
  spec.name          = 'satutempat_locale-server'
  spec.version       = SatutempatLocale::Server::VERSION
  spec.authors       = ['Teja Sophista V.R.']
  spec.email         = ['tejanium@yahoo.com']
  spec.description   = 'SatuTempat Locale Server'
  spec.summary       = 'SatuTempat Locale Server'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'database_cleaner'
  spec.add_development_dependency 'debugger'
  spec.add_runtime_dependency 'mongoid', '2.4.7' # uncomment this while doing test

  # spec.add_runtime_dependency 'mongoid', '~> 2.4.7'
  spec.add_runtime_dependency 'bson_ext'
  spec.add_runtime_dependency 'minitar'
end
