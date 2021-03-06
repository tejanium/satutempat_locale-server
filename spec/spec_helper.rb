require 'satutempat_locale/server'
require 'database_cleaner'

RSpec.configure do |config|
  config.before :suite do
    DatabaseCleaner[:mongoid].clean_with :truncation
    DatabaseCleaner[:mongoid].strategy = :truncation
  end

  config.after :each do
    DatabaseCleaner[:mongoid].clean
  end

  def stub_global_marker time
    global_marker = mock 'global_marker'
    global_marker.stub last_update: time
    global_marker.stub set: true
    SatutempatLocale::Server::GlobalMarker.stub first: global_marker
    SatutempatLocale::Server::GlobalMarker.stub create: true
  end
end
